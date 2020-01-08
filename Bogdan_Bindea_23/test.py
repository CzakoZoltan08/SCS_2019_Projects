import cv2
import time
import sys

font = cv2.FONT_HERSHEY_SIMPLEX
img = cv2.resize(cv2.imread(sys.argv[1]),(1080,1080),interpolation = cv2.INTER_CUBIC)
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
haar_cascade_face = cv2.CascadeClassifier('data\haarcascade_frontalface_default.xml')
haar_cascade_eye = cv2.CascadeClassifier('data\haarcascade_eye.xml')
haar_cascade_mouth = cv2.CascadeClassifier('data\haarcascade_mouth.xml')
haar_cascade_nose = cv2.CascadeClassifier('data\haarcascade_nose.xml')

while True:
    key=cv2.waitKey(20)
    cv2.imshow('window',img)
    face_coordinates = haar_cascade_face.detectMultiScale(gray, scaleFactor = 1.2, minNeighbors = 5);
    eye_coordinates= haar_cascade_eye.detectMultiScale(gray, scaleFactor = 1.5, minNeighbors = 4);
    nose_coordinates= haar_cascade_nose.detectMultiScale(gray, scaleFactor = 1.3, minNeighbors = 5);
    mouth_coordinates= haar_cascade_mouth.detectMultiScale(gray, scaleFactor = 2.1, minNeighbors = 5);
    for (x1,y1,w1,h1) in face_coordinates:
     cv2.rectangle(img, (x1, y1), (x1+w1, y1+h1), (0, 255, 0), 2)
     cv2.putText(img,'Face',(x1+w1,y1+h1), font, 2, (0, 255, 0), 2, cv2.LINE_AA)
    for (x1,y1,w1,h1) in mouth_coordinates:
     cv2.rectangle(img, (x1, y1), (x1+w1, y1+h1), (255, 255, 0), 2)
     cv2.putText(img,'Mouth',(x1+w1,y1+h1), font, 2, (255, 255, 0), 2, cv2.LINE_AA)
    for (x2,y2,w2,h2) in eye_coordinates:
     cv2.rectangle(img, (x2, y2), (x2+w2, y2+h2), (255, 0, 0), 2)
     cv2.putText(img,'Eye',(x2+w2,y2+h2), font, 2, (255, 0, 0), 2, cv2.LINE_AA)
    for (x3,y3,w3,h3) in nose_coordinates:
     cv2.rectangle(img, (x3, y3), (x3+w3, y3+h3), (0, 0, 255), 2)
     cv2.putText(img,'Nose',(x3+w3,y3+h3), font, 2, (0, 0, 255), 2, cv2.LINE_AA)
    if key == 27:
        break
cv2.destroyAllWindows()