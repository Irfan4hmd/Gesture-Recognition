
import cv2
import numpy as np
import logging
import tensorflow as tf


class GestureRecognizer:
    def __init__(self, model_path):
        self.model_path = model_path
        self.labels = ["Hello", "Stop", "Yes", "No", "Help"]  # Update as per your model
        self._load_model()

    def _load_model(self):
        logging.info(f"Loading TFLite CNN model from {self.model_path}...")
        try:
            self.interpreter = tf.lite.Interpreter(model_path=self.model_path)
            self.interpreter.allocate_tensors()
            self.input_details = self.interpreter.get_input_details()
            self.output_details = self.interpreter.get_output_details()
            logging.info("Model loaded successfully.")
        except Exception as e:
            logging.error(f"Failed to load model: {e}")
            raise

    def preprocess(self, frame):
        # Resize and normalize as per model requirements (assuming 224x224x3 and [0,1] normalization)
        img = cv2.resize(frame, (224, 224))
        img = img.astype(np.float32) / 255.0
        img = np.expand_dims(img, axis=0)
        return img

    def predict(self, frame):
        input_data = self.preprocess(frame)
        self.interpreter.set_tensor(self.input_details[0]['index'], input_data)
        self.interpreter.invoke()
        output_data = self.interpreter.get_tensor(self.output_details[0]['index'])
        # Assuming output is a softmax vector
        confidence = float(np.max(output_data))
        gesture_idx = int(np.argmax(output_data))
        gesture = self.labels[gesture_idx] if gesture_idx < len(self.labels) else "Unknown"
        return gesture, confidence
