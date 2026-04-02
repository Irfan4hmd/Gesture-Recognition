import cv2
import time
import yaml
import logging
import subprocess
from gesture_recognizer import GestureRecognizer

# Configure logging for systemd journal
logging.basicConfig(level=logging.INFO, format='%(levelname)s: %(message)s')

def load_config(config_path="config/settings.yaml"):
    with open(config_path, 'r') as file:
        return yaml.safe_load(file)

def speak(text):
    """Uses espeak for lightweight TTS on edge devices."""
    logging.info(f"Speaking: {text}")
    subprocess.run(["espeak", text])

def main():
    config = load_config()
    logging.info("Starting Gesture-to-Speech HRI Interface...")
    
    # Initialize camera
    cap = cv2.VideoCapture(config['camera']['device_id'])
    cap.set(cv2.CAP_PROP_FRAME_WIDTH, config['camera']['width'])
    cap.set(cv2.CAP_PROP_FRAME_HEIGHT, config['camera']['height'])
    
    if not cap.isOpened():
        logging.error("Failed to open camera. Check drivers and device ID.")
        # Note: Rollback config via Git if camera driver update breaks this!
        return

    recognizer = GestureRecognizer(config['model']['path'])
    
    last_gesture = None
    cooldown = config['app']['speech_cooldown']
    last_speech_time = 0

    try:
        while True:
            ret, frame = cap.read()
            if not ret:
                logging.warning("Dropped frame.")
                continue
                
            # Inference
            gesture, confidence = recognizer.predict(frame)
            
            if confidence > config['model']['confidence_threshold']:
                if gesture != last_gesture and (time.time() - last_speech_time) > cooldown:
                    speak(f"Detected {gesture}")
                    last_gesture = gesture
                    last_speech_time = time.time()
                    
            # Sleep to yield CPU resources
            time.sleep(1.0 / config['camera']['fps'])
            
    except KeyboardInterrupt:
        logging.info("Shutting down gracefully...")
    finally:
        cap.release()

if __name__ == "__main__":
    main()
