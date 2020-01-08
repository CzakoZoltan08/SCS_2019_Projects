import cv2
font = cv2.FONT_HERSHEY_SIMPLEX
haar_cascade_face = cv2.CascadeClassifier('data\haarcascade_frontalface_default.xml')
haar_cascade_eye = cv2.CascadeClassifier('data\haarcascade_eye.xml')
haar_cascade_mouth = cv2.CascadeClassifier('data\haarcascade_mouth.xml')
haar_cascade_nose = cv2.CascadeClassifier('data\haarcascade_nose.xml')
cv2.namedWindow("window")
cap = cv2.VideoCapture(0)
if cap.isOpened(): 
    rval, frame = cap.read()
else:
    rval = False
while rval:
    cv2.imshow("window", frame)
    rval, frame = cap.read()
    key = cv2.waitKey(20)
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    face_coordinates = haar_cascade_face.detectMultiScale(gray, scaleFactor=1.2, minNeighbors=5);
    eye_coordinates = haar_cascade_eye.detectMultiScale(gray, scaleFactor=1.5, minNeighbors=4);
    nose_coordinates = haar_cascade_nose.detectMultiScale(gray, scaleFactor=1.3, minNeighbors=5);
    mouth_coordinates = haar_cascade_mouth.detectMultiScale(gray, scaleFactor=1.7, minNeighbors=11);
    for (x1,y1,w1,h1) in face_coordinates:
     cv2.rectangle(frame, (x1, y1), (x1+w1, y1+h1), (255, 0, 0), 2)
     cv2.putText(frame,'Face',(x1+w1,y1+h1), font, 2, (255, 0, 0), 2, cv2.LINE_AA)
    for (x2,y2,w2,h2) in eye_coordinates:
     cv2.rectangle(frame, (x2, y2), (x2+w2, y2+h2), (255, 255, 0), 2)
     cv2.putText(frame,'Eye',(x2+w2,y2+h2), font, 2, (255, 255, 0), 2, cv2.LINE_AA)
    for (x3,y3,w3,h3) in nose_coordinates:
     cv2.rectangle(frame, (x3, y3), (x3+w3, y3+h3), (255, 0, 255), 2)
     cv2.putText(frame,'Nose',(x3+w3,y3+h3), font, 2, (255, 0, 255), 2, cv2.LINE_AA)
    for (x4,y4,w4,h4) in mouth_coordinates:
     y4 = int(y4 - 0.15 * h4)
     cv2.rectangle(frame, (x4, y4), (x4+w4, y4+h4), (0, 255, 0), 2)
     cv2.putText(frame,'Mouth',(x4+w4,y4+h4), font, 2, (0, 255, 0), 2, cv2.LINE_AA)
    if key == 27: 
        break
cap.release()
cv2.destroyAllWindows()

