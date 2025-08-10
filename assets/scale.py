import os
from PIL import Image
for f in os.listdir():
	if f.lower().endswith((".png",".jpg",".jpeg",".bmp",".gif",".tiff",".webp")):
		i=Image.open(f)
		i=i.resize((i.width//2,i.height//2),Image.LANCZOS)
		i.save(f)
