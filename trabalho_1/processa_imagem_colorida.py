from PIL import Image

def imagem_para_txt(imagem_caminho, arquivo_saida):
    img = Image.open(imagem_caminho)
    
    # redimensionar para 640x480
    img = img.resize((640, 480), Image.ANTIALIAS)
    
    img = img.convert("RGB")
    largura, altura = img.size
    pixels = img.load()
    
    with open(arquivo_saida, "w") as arquivo:
        for y in range(altura):
            for x in range(largura):
                r, g, b = pixels[x, y]
                arquivo.write(f"{r:08b}{g:08b}{b:08b}\n")
    
    print(f"Imagem convertida para {arquivo_saida}, redimensionada para 640x480")

# imagem_para_txt("imagem.jpg", "bandeira_colorida.txt")
