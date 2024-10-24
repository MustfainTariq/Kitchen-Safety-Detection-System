import argparse
import os
import datetime
import cv2
from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.responses import JSONResponse
from ultralytics import YOLO
import logging
import io
import base64

app = FastAPI()

@app.get("/")
async def hello_world():
    return {"message": "Welcome to the YOLO FastAPI Application"}

@app.post("/predict")
async def predict_img(file: UploadFile = File(...)):
    if file.filename == '':
        raise HTTPException(status_code=400, detail="No file selected")

    original_filename = file.filename
    file_extension = original_filename.rsplit('.', 1)[1].lower()
    time_now = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    new_filename = f"image0_{time_now}.{file_extension}"
    basepath = os.path.dirname(__file__)
    filepath = os.path.join(basepath, 'uploads', new_filename)

    with open(filepath, "wb") as buffer:
        buffer.write(await file.read())

    if file_extension == 'jpg':
        img = cv2.imread(filepath)
        log_capture_string = io.StringIO()
        ch = logging.StreamHandler(log_capture_string)
        ch.setLevel(logging.DEBUG)

        logger = logging.getLogger('ultralytics')
        logger.addHandler(ch)

        model = YOLO('best.pt')
        results = model(img)
        results[0].save()

        logger.removeHandler(ch)
        log_contents = log_capture_string.getvalue()
        log_capture_string.close()
        
        processed_filepath = 'results_image0.jpg'
        current_directory = os.getcwd()
        complete_path = os.path.join(current_directory, processed_filepath)

        # Convert image to Base64 string
        with open(complete_path, "rb") as image_file:
            encoded_string = base64.b64encode(image_file.read()).decode('utf-8')

        response = {
            'message': log_contents,
            'image': encoded_string
        }

        return JSONResponse(content=response)

    raise HTTPException(status_code=400, detail="Unsupported file extension")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="FastAPI app exposing YOLO models")
    parser.add_argument("--port", default=8000, type=int, help="port number")
    args = parser.parse_args()

    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=args.port)
