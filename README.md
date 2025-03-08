# powershell-claudealttest

A simple repository for experimenting with PowerShell scripts. Use it to test commands, learn scripting patterns, and share scripts with other developers.

## Getting Started

1. Clone this repository.
2. Run the PowerShell scripts locally or within your preferred environment.
3. Modify and experiment as needed.

## Running Scripts
The script `upload-image.ps1` requires an image file to be passed in a parameter. The script will upload the image to a specified URL.

```powershell
.\upload-image.ps1 "C:\path\to\image.jpg"
```

## Credits and inspiration
This was inspired by [Simon Willison](https://simonwillison.net/2025/Mar/2/accessibility-and-gen-ai/), who mentioned the idea of using AI to generate alt text for images. The instruction string in `upload-image.ps1` is borrowed from him.

## Contributing

Feel free to open issues or pull requests to suggest enhancements or bug fixes.
