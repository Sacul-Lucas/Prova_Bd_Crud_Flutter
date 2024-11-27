import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter CRUD',
      home: Scaffold(
        appBar: AppBar(title: Text('Flutter CRUD')),
        body: CRUDPage(),
      ),
    );
  }
}

class CRUDPage extends StatefulWidget {
  @override
  _CRUDPageState createState() => _CRUDPageState();
}

class _CRUDPageState extends State<CRUDPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  List<dynamic> users = [];
  bool isReading = false; // Variável para controlar a visibilidade da lista
  bool isEditing = false; // Variável para controlar se está em edição

  String editingId = ''; // Para controlar qual usuário está sendo editado

  @override
  void initState() {
    super.initState();
    readRecords();
  }

  // Create - Criar um novo registro
  void createRecord() async {
    var url = Uri.parse('http://localhost/crud_flutter_app/Create.php');
    var response = await http.post(url, body: {
      'name': nameController.text,
      'email': emailController.text,
    });
    print(response.body);
    if (response.statusCode == 200) {
      readRecords(); // Atualiza a lista de registros após criação
    }
  }

  // Read - Ler os registros
  void readRecords() async {
    var url = Uri.parse('http://localhost/crud_flutter_app/Read.php');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        users = json.decode(response
            .body); // Preenche a lista de usuários com os dados do servidor
        if (!isEditing)
          isReading =
              !isReading; // Alterna a visibilidade da lista, caso não esteja em edição
      });
    }
  }

  // Update - Atualizar um registro existente
  void updateRecord() async {
    var url = Uri.parse('http://localhost/crud_flutter_app/Update.php');
    var response = await http.post(url, body: {
      'id': editingId,
      'name': nameController.text,
      'email': emailController.text,
    });
    print(response.body);
    if (response.statusCode == 200) {
      readRecords(); // Atualiza a lista de registros após atualização
      // Limpar os campos após a atualização
      nameController.clear();
      emailController.clear();
      setState(() {
        isEditing = false; // Volta para o estado de leitura
      });
    }
  }

  // Cancelar a edição e voltar ao estado inicial
  void cancelEdit() {
    setState(() {
      nameController.clear();
      emailController.clear();
      isEditing = false; // Volta para o estado de leitura
    });
  }

  // Delete - Excluir um registro
  void deleteRecord(String id) async {
    var url = Uri.parse('http://localhost/crud_flutter_app/Delete.php');
    var response = await http.post(url, body: {
      'id': id, // Passando o id como String
    });
    print(response.body);
    if (response.statusCode == 200) {
      readRecords(); // Atualiza a lista de registros após exclusão
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.center, // Centraliza o conteúdo da coluna
        children: [
          // Exibir campos de nome e email apenas se não estiver em edição
          if (!isEditing) ...[
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: createRecord,
                child: Text('Registrar'),
              ),
            ),
            ElevatedButton(
              onPressed: readRecords,
              child: Text(isReading ? 'Esconder usuários' : 'Mostrar usuários'),
            ),
          ],
          Divider(),
          // Mostrar a lista de usuários se não estiver em edição
          if (isReading && !isEditing)
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(users[index]['name']),
                    subtitle: Text(users[index]['email']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Preenche os campos de edição com os dados do usuário
                            nameController.text = users[index]['name'];
                            emailController.text = users[index]['email'];
                            setState(() {
                              isEditing = true;
                              editingId = users[index]['id']
                                  .toString(); // Marca qual usuário está sendo editado
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            // Passando o id como String para exclusão
                            deleteRecord(users[index]['id'].toString());
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          // Se estiver em edição, exibir os campos e botões de "Confirmar" e "Cancelar"
          if (isEditing) ...[
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: updateRecord,
                  child: Text('Confirmar'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: cancelEdit,
                  child: Text('Cancelar'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
