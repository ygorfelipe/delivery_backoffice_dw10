import 'dart:html';
import 'dart:typed_data';

typedef UploadCallBack = void Function(Uint8List file, String fileName);

class UploadHtmlHelper {
  //* primeiro metodo é para iniciar a seleção, ou seja, clicou em adicionar imagem, aparece a tela para escolher onde a imagem esta
  //* onde o mesmo irá ficar escutando na seleção quais são os arquivos
  //* o handleFileUpload ele vai mandar para frente
  void startUpload(UploadCallBack callBack) {
    final uploadInput = FileUploadInputElement();
    uploadInput.click();
    uploadInput.onChange.listen((_) {
      handleFileUpload(uploadInput, callBack);
    });
  }

  //* aqi é feito a leitura da imagem
  //* pegando o primeiro dele, e fazendo uma leitura em memoria "local"
  //* será feita a conversão de array de bits, e enviar novamente para frente
  void handleFileUpload(
    FileUploadInputElement uploadInput,
    UploadCallBack callBack,
  ) {
    final files = uploadInput.files;
    if (files != null && files.isNotEmpty) {
      final file = files.first;
      final reader = FileReader();
      reader.readAsArrayBuffer(file);
      reader.onLoadEnd.listen((_) {
        final bytes = Uint8List.fromList(reader.result as List<int>);
        callBack(bytes, file.name);
      });
    }
  }
}
