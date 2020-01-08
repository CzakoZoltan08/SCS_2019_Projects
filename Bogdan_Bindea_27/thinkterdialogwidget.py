from tkinter import *
from tkinter import ttk
from tkinter import filedialog
import inspect
import os

class Root(Tk):
    def __init__(self):
        super(Root, self).__init__()
        self.title("Morphological face features detection")
        self.minsize(400, 100)

        self.labelFrame = ttk.LabelFrame(self, text="Start Program")
        self.labelFrame.grid(column=0, row=1, padx=20, pady=20)

        self.button()

    def button(self):
        self.button = ttk.Button(self.labelFrame, text="Browse", command=self.fileDialog)
        self.button.grid(column=1, row=1)
        self.button = ttk.Button(self.labelFrame, text="Camera", command=self.camera)
        self.button.grid(column=3, row=1)

    def fileDialog(self):
        self.filename = filedialog.askopenfilename(initialdir="/", title="Select A File", filetype=
        (("jpeg files", "*.jpg"),("jpeg files", "*.jpeg"), ("all files", "*.*")))
        self.label = ttk.Label(self.labelFrame, text="")
        self.label.grid(column=1, row=2)
        command = "C:\\Users\\binde\\Desktop\\scsproject\\test.py "
        command=command+self.filename
        os.system(command)

    def camera(self):
        command = "C:\\Users\\binde\\Desktop\\scsproject\\scs.py "
        os.system(command)


root = Root()
root.mainloop()
