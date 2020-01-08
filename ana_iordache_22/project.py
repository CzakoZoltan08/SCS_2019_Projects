from imutils.video import VideoStream
import argparse
import datetime
import imutils
import time
import cv2

def intersects(p1, p2, x, y, w, h):

	x1 = max(p1[0], x)
	y1 = max(p1[1], y)
	x2 = min(p2[0], x + w)
	y2 = min(p2[1], y + h)

	width = x2 - x1
	height = y2 - y1

	if (width < 0) or (height < 0):
		overlap = 0
	else:
		overlap = width * height
	return overlap > 0

red = (0, 0, 255)

MIN_AREA = 500

r1p1 = (50,60)
r1p2 = (100, 95)
r2p1 = (250,260)
r2p2 = (300, 295)
r3p1 = (50, 200)
r3p2 = (100, 230)

ap = argparse.ArgumentParser()
ap.add_argument("-v", "--video", help="path to the video file")
args = vars(ap.parse_args())

if args.get("video", None) is None:
	vs = VideoStream(src=0).start()
	time.sleep(2.0)

else:
	vs = cv2.VideoCapture(args["video"])

firstFrame = None



while True:

	frame = vs.read()
	frame = frame if args.get("video", None) is None else frame[1]
	text = "Unoccupied"

	if frame is None:
		break

	frame = imutils.resize(frame, width=500)
	gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
	gray = cv2.GaussianBlur(gray, (21, 21), 0)

	cv2.rectangle(frame, r1p1, r1p2, red, -1)
	cv2.rectangle(frame, r2p1, r2p2, red, -1)
	cv2.rectangle(frame, r3p1, r3p2, red, -1)

	if firstFrame is None:
		firstFrame = gray
		continue

	frameDelta = cv2.absdiff(firstFrame, gray)
	thresh = cv2.threshold(frameDelta, 25, 255, cv2.THRESH_BINARY)[1]

	
	thresh = cv2.dilate(thresh, None, iterations=2)
	cnts = cv2.findContours(thresh.copy(), cv2.RETR_EXTERNAL,
		cv2.CHAIN_APPROX_SIMPLE)
	cnts = imutils.grab_contours(cnts)

	for c in cnts:
	
		if cv2.contourArea(c) < MIN_AREA:
			continue

		(x, y, w, h) = cv2.boundingRect(c)
		cv2.rectangle(frame, (x, y), (x + w, y + h), (0, 255, 0), 2)
		text = "Stuff is moving"
		
		if intersects(r1p1, r1p2, x, y, w, h) | intersects(r2p1, r2p2, x, y, w, h) | intersects(r3p1, r3p2, x, y, w, h):
			text = "WARNING"

	
	cv2.putText(frame, "Status: {}".format(text), (10, 20),
		cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 0, 255), 2)
	cv2.putText(frame, datetime.datetime.now().strftime("%A %d %B %Y %I:%M:%S%p"),
		(10, frame.shape[0] - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.35, (0, 0, 255), 1)

	
	cv2.imshow("Security Feed", frame)
	cv2.imshow("Thresh", thresh)
	cv2.imshow("Frame Delta", frameDelta)
	key = cv2.waitKey(1) & 0xFF

	if key == 27:
		break
	elif (key == 82) | (key == 114):
		firstFrame = gray


vs.stop() if args.get("video", None) is None else vs.release()
cv2.destroyAllWindows()