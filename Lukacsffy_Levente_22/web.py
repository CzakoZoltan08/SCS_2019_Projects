#!/usr/bin/env python
from flask import Flask, render_template, Response

import cv2
import pygame
import time
frequency=2500
duration=5
pygame.mixer.init()
pygame.mixer.music.load(open('beep.wav'))
app = Flask(__name__)


@app.route('/')
def index():
    """Streaming page."""
    return render_template('index.html')

def gen():

    videocap = cv2.VideoCapture(0)
    basef = None
    hasrect=False
    beeped=0
    frame = videocap.read()[1]
    time.sleep(3)

    while True:
        frame = videocap.read()[1]
        text = 'No movement detected'
        beeped += 1
        greayscalef = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        gaussian = cv2.GaussianBlur(greayscalef, (21, 21), 0)

        if basef is None:
            basef = gaussian
        else:
            pass

        #frame = imutils.resize(frame, width=500)
        delta = cv2.absdiff(basef, gaussian)
        thresh = cv2.threshold(delta, 100, 255, cv2.THRESH_BINARY)[1]
        dilated = cv2.dilate(thresh, None, iterations=1)
        #  cnt = cv2.findContours(dilated.copy(), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)[1]
        cnts, notused= cv2.findContours(dilated.copy(), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

        for i in cnts:
            beeped += 1
            if cv2.contourArea(i) > 400:
                (x, y, w, h) = cv2.boundingRect(i)
                if not hasrect:
                    cv2.rectangle(frame, (x-50, y-50), (x + w-50, y + h-50), (255, 255, 255), 3)
                text = 'Movement detected'
                if beeped % 10 == 0:
                    pygame.mixer.music.play()
                hasrect=True
            else:
                pass
       # pygame.mixer.music.stop()
        font = cv2.FONT_ITALIC
        cv2.putText(frame, 'In the room: %s' % (text), (10, 20), cv2.FONT_ITALIC, 0.5, (0, 0, 255), 2)
        cv2.imshow('Security Feed', frame)
        cv2.imshow('Threshold(foreground mask)', dilated)
        cv2.imshow('Delta', delta)
        hasrect=False
        key = cv2.waitKey(1) & 0xFF
        if key == ord('q'):

            cv2.destroyAllWindows()
            break

        cv2.imwrite(filename='saved_img.jpg', img=frame)
        img_new = cv2.imread('saved_img.jpg', cv2.IMREAD_GRAYSCALE)
        yield (b'--frame\r\n'b'Content-Type: image/jpeg\r\n\r\n' + cv2.imencode('.jpg', img_new)[1].tobytes() + b'\r\n')
        #yield cv2.imencode('.jpg', img_new)[1].tobytes()
       
@app.route('/video_feed')
def video_feed():
    """Video streaming route. Put this in the src attribute of an img tag."""
    return Response(gen(), mimetype='multipart/x-mixed-replace; boundary=frame')


if __name__ == '__main__':
   # x = threading.Thread(target=thread_function)
    # x.start()
    app.run(host='0.0.0.0', debug=True, threaded=True)