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

        self.create_widgets()

    def create_widgets(self):
        self.input_method_label = tk.Label(self.root, text="Select input method for folder names:")
        self.input_method_label.pack(pady=5)

        self.input_method_var = tk.StringVar(value="file")
        tk.Radiobutton(self.root, text="Select file", variable=self.input_method_var, value="file", command=self.update_input_method).pack()
        tk.Radiobutton(self.root, text="Manual input", variable=self.input_method_var, value="manual", command=self.update_input_method).pack()

        self.input_file_frame = tk.Frame(self.root)
        self.input_file_label = tk.Label(self.input_file_frame, text="Select the text file with folder names:")
        self.input_file_label.pack(side=tk.LEFT, padx=5)
        self.input_file_button = tk.Button(self.input_file_frame, text="Browse", command=self.browse_input_file)
        self.input_file_button.pack(side=tk.LEFT, padx=5)
        self.input_file_frame.pack(pady=5)

        self.manual_input_frame = tk.Frame(self.root)
        self.manual_input_label = tk.Label(self.manual_input_frame, text="Enter folder names (comma-separated):")
        self.manual_input_label.pack(side=tk.LEFT, padx=5)
        self.manual_input_entry = tk.Entry(self.manual_input_frame, width=50)
        self.manual_input_entry.pack(side=tk.LEFT, padx=5)

        self.files_to_copy_label = tk.Label(self.root, text="Select the file(s) to copy into each folder:")
        self.files_to_copy_label.pack(pady=5)
        self.files_to_copy_button = tk.Button(self.root, text="Browse", command=self.browse_files_to_copy)
        self.files_to_copy_button.pack(pady=5)

        self.execute_button = tk.Button(self.root, text="Create Folders and Copy Files", command=self.execute)
        self.execute_button.pack(pady=20)

        self.status_message = tk.Label(self.root, text="", fg="green")
        self.status_message.pack(pady=5)

        self.update_input_method()

    def update_input_method(self):
        if self.input_method_var.get() == "file":
            self.input_file_frame.pack(pady=5)
            self.manual_input_frame.pack_forget()
        else:
            self.input_file_frame.pack_forget()
            self.manual_input_frame.pack(pady=5)

    def browse_input_file(self):
        self.input_file = filedialog.askopenfilename(title="Select the text file", filetypes=(("Text files", "*.txt"), ("All files", "*.*")))
        if self.input_file:
            self.input_file_label.config(text=f"Selected file: {self.input_file}")

    def browse_files_to_copy(self):
        self.files_to_copy = filedialog.askopenfilenames(title="Select the file(s) to copy")
        if self.files_to_copy:
            self.files_to_copy_label.config(text=f"Selected files: {', '.join(self.files_to_copy)}")

    def execute(self):
        folder_names = []

        if self.input_method_var.get() == "file":
            if not self.input_file:
                messagebox.showerror("Error", "Please select the text file with folder names.")
                return
            try:
                with open(self.input_file, 'r') as f:
                    folder_names = f.read().splitlines()
            except Exception as e:
                self.status_message.config(text=f"Error: {str(e)}", fg="red")
                return
        else:
            manual_input = self.manual_input_entry.get()
            if not manual_input:
                messagebox.showerror("Error", "Please enter folder names.")
                return
            folder_names = [name.strip() for name in manual_input.split(',')]

        if not self.files_to_copy:
            proceed = messagebox.askyesno("No Files Selected", "You have selected no files to copy into each folder. Would you like to go back or proceed?")
            if not proceed:
                return

        try:
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

