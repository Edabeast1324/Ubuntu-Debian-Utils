// Initial project files structure
const projectFiles = {
    "index.html": "<!DOCTYPE html><html lang='en'><head><meta charset='UTF-8'><title>Firebase Studio Clone</title></head><body><h1>Welcome to Firebase Studio Clone</h1><script src='script.js'></script></body></html>",
    "styles.css": "body { font-family: Arial, sans-serif; background-color: #f4f4f4; }",
    "script.js": "console.log('JavaScript Loaded!');",
};

// Keep track of the current file being edited
let currentFile = null;

// Function to update the file explorer
function updateFileExplorer() {
    const fileList = document.getElementById("file-list");
    fileList.innerHTML = '';

    Object.keys(projectFiles).forEach(fileName => {
        const li = document.createElement("li");
        li.textContent = fileName;
        li.onclick = () => loadFile(fileName);
        li.classList.toggle('selected', fileName === currentFile);

        // Add "Download" button next to each file in the explorer
        const downloadButton = document.createElement("button");
        downloadButton.textContent = "Download";
        downloadButton.onclick = (e) => {
            e.stopPropagation(); // Prevent click event from loading file
            downloadFile(fileName); // Trigger file download
        };

        li.appendChild(downloadButton);
        fileList.appendChild(li);
    });
}

// Function to load a file into the editor
function loadFile(fileName) {
    currentFile = fileName;
    const fileContent = projectFiles[fileName];
    const editorContainer = document.getElementById("editor-container");

    editorContainer.innerHTML = '';
    
    if (fileName.endsWith(".html")) {
        const textarea = document.createElement("textarea");
        textarea.value = fileContent;
        textarea.id = "html-editor";
        editorContainer.appendChild(textarea);
    } else if (fileName.endsWith(".css")) {
        const textarea = document.createElement("textarea");
        textarea.value = fileContent;
        textarea.id = "css-editor";
        editorContainer.appendChild(textarea);
    } else if (fileName.endsWith(".js")) {
        const textarea = document.createElement("textarea");
        textarea.value = fileContent;
        textarea.id = "js-editor";
        editorContainer.appendChild(textarea);
    }

    updatePreview();
    updateFileExplorer();
}

// Function to create a new file
function createFile() {
    const fileName = prompt("Enter the name of the new file (e.g., newFile.html):");
    if (fileName) {
        projectFiles[fileName] = "";
        currentFile = fileName;
        updateFileExplorer();
        loadFile(fileName);
    }
}

// Function to save the file
function saveFile() {
    const editor = document.querySelector("textarea");
    if (editor) {
        projectFiles[currentFile] = editor.value;
        alert("File saved successfully!");
        updatePreview();
    }
}

// Function to update the preview window
function updatePreview() {
    const iframe = document.getElementById("preview-frame");
    const htmlContent = projectFiles["index.html"];
    const cssContent = projectFiles["styles.css"];
    const jsContent = projectFiles["script.js"];

    let iframeDocument = iframe.contentDocument || iframe.contentWindow.document;
    iframeDocument.open();
    iframeDocument.write(htmlContent); // Inject HTML content

    // Inject CSS if available
    if (cssContent) {
        const styleTag = iframeDocument.createElement("style");
        styleTag.innerHTML = cssContent;
        iframeDocument.head.appendChild(styleTag);
    }

    // Inject JS if available
    if (jsContent) {
        const scriptTag = iframeDocument.createElement("script");
        scriptTag.innerHTML = jsContent;
        iframeDocument.body.appendChild(scriptTag);
    }

    iframeDocument.close();
}

// Function to handle file upload
function uploadFile() {
    const input = document.createElement('input');
    input.type = 'file';
    input.accept = '.html,.css,.js,image/*';  // Accept HTML, CSS, JS, and images
    input.multiple = true; // Allow multiple file uploads

    input.onchange = (event) => {
        const files = event.target.files;
        Array.from(files).forEach(file => {
            const reader = new FileReader();
            reader.onload = (e) => {
                const fileContent = e.target.result;
                const fileName = file.name;

                // Handle each file type
                if (fileName.endsWith(".html") || fileName.endsWith(".css") || fileName.endsWith(".js")) {
                    projectFiles[fileName] = fileContent;
                } else if (fileName.match(/\.(jpeg|jpg|png|gif)$/)) {
                    // Handle image files: add image tag to HTML file
                    const imgTag = `<img src="${fileContent}" alt="${fileName}" width="100%" />`;
                    const htmlFile = projectFiles["index.html"];
                    projectFiles["index.html"] = htmlFile + imgTag;
                }
                updateFileExplorer();
            };

            // If it's an image, we'll handle it differently
            if (file.name.match(/\.(jpeg|jpg|png|gif)$/)) {
                reader.readAsDataURL(file); // Read as DataURL for images
            } else {
                reader.readAsText(file); // Read as text for HTML, CSS, and JS files
            }
        });
    };

    input.click();
}

// Function to download a file in a new tab
function downloadFile(fileName) {
    const fileContent = projectFiles[fileName];
    const blob = new Blob([fileContent], { type: "text/plain" });

    // Create a new window/tab
    const downloadTab = window.open('', '_blank');

    // Create the download link inside the new tab using document.write
    downloadTab.document.write(`
        <!DOCTYPE html>
        <html>
        <head>
            <title>Downloading ${fileName}</title>
        </head>
        <body>
            <h3>Your download will start shortly...</h3>
            <a id="download-link" href="${URL.createObjectURL(blob)}" download="${fileName}">Click here if the download does not start automatically</a>
            <script>
                // Automatically trigger download after the page loads
                const link = document.getElementById('download-link');
                link.click();
                
                // Close the tab after a short delay to allow download to start
                setTimeout(() => {
                    window.close();
                }, 2000); // Close after 2 seconds to ensure the download starts
            </script>
        </body>
        </html>
    `);

    // This triggers the download in the new tab and closes it after a delay
}

// Initialize the app
updateFileExplorer();
