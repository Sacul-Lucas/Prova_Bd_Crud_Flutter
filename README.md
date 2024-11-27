# Prova_Bd_Crud_Flutter
CRUD básico feito com Flutter, Mysql e PHP

Tarefa desenvolvida por: Lucas de Matos, Luann de Almeida Cunha e Hallony

Tutoriais e procedimentos para a instalação e configuração da aplicação CRUD:

1. Requisitos
Antes de começar, é importante ter alguns requisitos instalados e configurados:

  + Flutter SDK: Para desenvolver o aplicativo.
  + VS Code: Como editor de código.
  + XAMPP: Para configurar o servidor Apache e o banco de dados MySQL.
  + MySQL Workbench: Para gerenciar o banco de dados MySQL.
  + Dart e Flutter Extensions no VS Code: Para habilitar o suporte ao Flutter no VS Code.
  + Pacote http para comunicação com o banco de dados: No Flutter.

2. Instalação e Configuração do Ambiente
   
  Passo 1: Instalar o XAMPP e o Mysql Workbench
  
  * Download do XAMPP: Acesse o site oficial do XAMPP e baixe a versão adequada para seu sistema operacional (Windows, macOS, Linux).
  * Instalação: Siga o assistente de instalação.
  * Iniciar Apache e MySQL: Após a instalação, abra o XAMPP e inicie os serviços "Apache" e "MySQL".
  * Testar: No navegador, acesse http://localhost para verificar se o Apache está funcionando. Para o MySQL, você pode acessar http://localhost/phpmyadmin.

Download do Mysql Workbench: Acesse o site oficial do Mysql e baixe a versão adequada para seu sistema operacional (Windows, macOS, Linux).

Instalação: Siga o assistente de instalação e configure como usuario root sem senha (configuração padrão).

  Passo 2: Configuração do Banco de Dados no MySQL
  
  + Abrir o MySQL Workbench: Após iniciar o MySQL no XAMPP, abra o MySQL Workbench e conecte-se ao servidor local.
  + Criar o Banco de Dados: Execute o seguinte comando no MySQL Workbench para criar o banco de dados:
    ```mysql
      CREATE DATABASE crud_app;
      USE crud_app;
    ```
      
  + Criar Tabela de Exemplo:
    ```mysql
      CREATE TABLE users (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(100),
        email VARCHAR(100)
      );
    ```

  + Inserir Dados de Exemplo:
    ```mysql
      INSERT INTO users (name, email) VALUES ('Lucas', 'rei@daComputaria.com');
    ```

  Passo 3: Instalar o Flutter e Configurar o VS Code
  
  + Download do Flutter SDK: Acesse o site oficial do Flutter e siga o guia de instalação para seu sistema operacional.
  + Instalar o VS Code: Baixe e instale o VS Code aqui.
  + Instalar as Extensões: No VS Code, instale as extensões "Flutter" e "Dart" diretamente na Visual Studio Marketplace.
  + Para mais informações e detalhes mais específicos sobre a instalação, acesse: https://docs.flutter.dev/get-started/install/windows/mobile https://docs.flutter.dev/get-started/codelab

  Passo 4: Configuração do Flutter
  
  + Abra o terminal no VS Code e execute o seguinte comando para verificar a instalação do Flutter:,
    ```
      flutter doctor
    ```
  + Certifique-se de que não há problemas na instalação (o comando deve retornar "no issues found").

3. Desenvolvimento da Aplicação Flutter
   
  Passo 1: Criar um Novo Projeto Flutter
  
  + No VS Code, abra o terminal e execute:
    ```
      flutter create prova_bd_crud_flutter
      cd prova_bd_crud_flutter
    ```
   
  + Abra o projeto no VS Code (File > Open Folder e selecione a pasta prova_bd_crud_flutter).

  Passo 2: Adicionar Dependências
  
  + Abra o arquivo pubspec.yaml e adicione a dependência http para fazer a comunicação com o banco de dados:
    ```flutter
      dependencies:
        flutter:
          sdk: flutter
      http: ^0.13.3
    ```
  + Execute o comando abaixo para instalar as dependências:
    ```
      flutter pub get
    ```

  Passo 3: Desenvolver o Código para CRUD
  
  + Conexão com o Banco de Dados
      1. Para interagir com o MySQL, você pode criar uma API em PHP ou usar algum backend para expor os dados. Aqui, vou ilustrar uma simples API PHP que você pode usar localmente.
      
  + Criar os Arquivos PHP para a API CRUD: No diretório do XAMPP (C:\xampp\htdocs ou o caminho correspondente), crie uma pasta chamada crud_flutter_app e adicione os seguintes arquivos:
      1. conexao.php (para conectar ao MySQL):
         ```php
        <?php
          $servername = "localhost";
          $username = "root"; // default for XAMPP
          $password = ""; // default for XAMPP
          $dbname = "crud_app";

          $conn = new mysqli($servername, $username, $password, $dbname);
          if ($conn->connect_error) {
            die("Connection failed: " . $conn->connect_error);
          }
        ?>
        ```
      2. create.php (para criar um novo registro):
         ```php
        <?php
          include 'conexao.php';

          $name = $_POST['name'];
          $email = $_POST['email'];

          $sql = "INSERT INTO users (name, email) VALUES ('$name', '$email')";
          if ($conn->query($sql) === TRUE) {
            echo "New record created successfully";
          } else {
            echo "Error: " . $sql . "<br>" . $conn->error;
          }

          $conn->close();
        ?>
        ```
      3. read.php (para ler os registros):
         ```php
        <?php
          include 'Conexão.php';

          $sql = "SELECT * FROM users";
          $result = $conn->query($sql);

          $users = array();

          if ($result->num_rows > 0) {
            while ($row = $result->fetch_assoc()) {
              $users[] = $row; // Adiciona o usuário ao array
            }
            echo json_encode($users);
          } else {
            echo json_encode([]);
          }
          
          $conn->close();
          ?>
          ```

      4. update.php (para atualizar um registro):
         ```php
        <?php
          include 'conexao.php';

          $id = $_POST['id'];
          $name = $_POST['name'];
          $email = $_POST['email'];

          $sql = "UPDATE users SET name='$name', email='$email' WHERE id=$id";
          if ($conn->query($sql) === TRUE) {
            echo "Record updated successfully";
          } else {
            echo "Error: " . $sql . "<br>" . $conn->error;
          }

          $conn->close();
        ?>
         ```
      5. delete.php (para deletar um registro):
         ```php
        <?php
          include 'Conexão.php';

          if (isset($_POST['id'])) {
            $id = $_POST['id'];
            
            $sql = "DELETE FROM users WHERE id = ?";


            if ($stmt = $conn->prepare($sql)) {
              $stmt->bind_param('s', $id);
              if ($stmt->execute()) {
                echo "Registro deletado com sucesso.";
              } else {
                echo "Erro ao deletar o registro.";
              }
              $stmt->close();
            } else {
              echo "Erro na preparação da consulta.";
            }
          }

          $conn->close();
        ?>
        ```

Passo 4: Criar a Interface Flutter

Agora, você pode criar uma interface simples no Flutter para consumir essas APIs. Aqui está um exemplo básico de como fazer a requisição HTTP no Flutter.

 + Abra o arquivo lib/main.dart e substitua o conteúdo por:
 
```flutter
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

```




4. Passo a Passo para Executar a Aplicação
   + Inicie o XAMPP e os serviços Apache e MySQL.
   + Abra o MySQL Workbench e crie o banco de dados conforme mencionado.
   + Coloque os arquivos PHP na pasta htdocs/crud_flutter_app dentro do XAMPP.
   + No Flutter, abra o projeto e execute flutter run.
   + Teste as operações CRUD no Flutter.


  
