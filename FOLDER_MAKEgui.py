import tkinter as tk
from tkinter import filedialog, messagebox
import os
import shutil

class FolderCreatorApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Folder Creator App")

        self.input_file = ""
        self.files_to_copy = []

        # Create GUI elements
        self.create_widgets()

    def create_widgets(self):
        self.input_file_label = tk.Label(self.root, text="Select the text file with folder names:")
        self.input_file_label.pack(pady=5)

        self.input_file_button = tk.Button(self.root, text="Browse", command=self.browse_input_file)
        self.input_file_button.pack(pady=5)

        self.files_to_copy_label = tk.Label(self.root, text="Select the file(s) to copy into each folder:")
        self.files_to_copy_label.pack(pady=5)

        self.files_to_copy_button = tk.Button(self.root, text="Browse", command=self.browse_files_to_copy)
        self.files_to_copy_button.pack(pady=5)

        self.execute_button = tk.Button(self.root, text="Create Folders and Copy Files", command=self.execute)
        self.execute_button.pack(pady=20)

        self.status_message = tk.Label(self.root, text="", fg="green")
        self.status_message.pack(pady=5)

    def browse_input_file(self):
        self.input_file = filedialog.askopenfilename(title="Select the text file", filetypes=(("Text files", "*.txt"), ("All files", "*.*")))
        if self.input_file:
            self.input_file_label.config(text=f"Selected file: {self.input_file}")

    def browse_files_to_copy(self):
        self.files_to_copy = filedialog.askopenfilenames(title="Select the file(s) to copy")
        if self.files_to_copy:
            self.files_to_copy_label.config(text=f"Selected files: {', '.join(self.files_to_copy)}")

    def execute(self):
        if not self.input_file:
            messagebox.showerror("Error", "Please select the text file with folder names.")
            return

        if not self.files_to_copy:
            messagebox.showerror("Error", "Please select the file(s) to copy into each folder.")
            return

        try:
            with open(self.input_file, 'r') as f:
                folder_names = f.read().splitlines()

            for folder_name in folder_names:
                os.makedirs(folder_name, exist_ok=True)
                for file in self.files_to_copy:
                    shutil.copy(file, folder_name)

            self.status_message.config(text="Folders created and files copied successfully.", fg="green")
        except Exception as e:
            self.status_message.config(text=f"Error: {str(e)}", fg="red")

if __name__ == "__main__":
    root = tk.Tk()
    app = FolderCreatorApp(root)
    root.mainloop()

