# Template de Projeto Flutter

Este projeto serve como um template inicial para novos projetos Flutter. Ele inclui uma estrutura base com:
- Gerenciamento de estado com Provider
- Navegação com GoRouter
- Tratamento de erros com Result
- Logging configurado
- SharedPreferences para armazenamento local

## Script de Automação

O projeto inclui um script de automação para facilitar o processo de renomeação do projeto.

### Como usar o script:

1. Após clonar o repositório, exclua a pasta `.git` para iniciar um novo repositório:
   ```bash
   rm -rf .git
   ```

2. Dê permissão de execução ao script:

   Para Linux/macOS:
   ```bash
   chmod +x rename_project.sh
   ```

   Para Windows (PowerShell):
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

3. Execute o script passando o novo nome do projeto:

   Para Linux/macOS:
   ```bash
   ./rename_project.sh novo_nome_do_projeto
   ```

   Para Windows (PowerShell):
   ```powershell
   .\rename_project.sh novo_nome_do_projeto
   ```

## Observações Importantes

- O novo nome deve seguir as convenções de nomenclatura do Flutter (snake_case)
- Não use caracteres especiais no nome
- Certifique-se de que o nome é único no seu ambiente de desenvolvimento
- Após a renomeação, pode ser necessário limpar o cache do IDE e reiniciá-lo

## Estrutura do Projeto

```
lib/
  ├── data/
  │   ├── models/
  │   ├── repositories/
  │   └── services/
  ├── domain/
  │   ├── entities/
  │   ├── repositories/
  │   └── usecases/
  ├── presentation/
  │   ├── pages/
  │   ├── widgets/
  │   └── controllers/
  └── main.dart
```

## Dependências Principais

- provider: ^6.1.5
- go_router: ^15.1.2
- result_dart: ^2.1.0
- result_command: ^1.3.0
- logging: ^1.3.0
- shared_preferences: ^2.5.3
