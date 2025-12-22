# Documentação do Workflow: ci-merge-fastlane.yml

## Objetivo

Este workflow implementa um fluxo CI/CD seguro e automatizado para projetos Flutter, garantindo que apenas códigos testados sejam integrados à branch principal (main) e que automações sensíveis (como deploys via Fastlane) só ocorram após o merge.

---

## Como funciona o workflow

### 1. Testes em Pull Requests
- **Quando executa:**
  - Sempre que um pull request é aberto ou atualizado para a branch main.
- **O que faz:**
  - Faz checkout do código.
  - Instala o Flutter (versão 3.38.5).
  - Instala dependências (`flutter pub get`).
  - Executa os testes (`flutter test`).
- **Resultado esperado:**
  - Se os testes falharem, o merge é bloqueado.
  - Se os testes passarem, o merge pode ser realizado.

### 2. Execução do Fastlane após Merge
- **Quando executa:**
  - Sempre que ocorre um push na branch main (ou seja, após o merge de um PR aprovado).
- **O que faz:**
  - Faz checkout do código.
  - Executa um script de emulação do Fastlane (pode ser substituído pelo comando real do Fastlane no futuro).
- **Resultado esperado:**
  - O script só roda após o merge, nunca durante o PR.

---

## Resumo do fluxo
1. Desenvolvedor abre um PR para a main.
2. Workflow executa os testes.
3. Se os testes passarem, o PR pode ser mergeado.
4. Após o merge (push na main), o workflow executa o script do Fastlane.

---


## Como garantir merges protegidos
Se quiser garantir que o merge só seja possível após os testes passarem, ative a proteção de branch main no GitHub:

1. Vá em Settings > Branches > Branch protection rules no GitHub.
2. Crie uma regra para a branch main.
3. Marque "Require status checks to pass before merging" e selecione o check do workflow.

Assim, o GitHub só permitirá o merge se todos os testes do workflow passarem, aumentando a segurança do seu fluxo CI/CD.

---

## Exemplo do arquivo `.github/workflows/ci-merge-fastlane.yml`

```yaml
name: CI com Merge Protegido e Fastlane

on:
  pull_request:
    branches: [ main ]
  push:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    if: github.event_name == 'pull_request'
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.38.5'
      - run: flutter pub get
      - run: flutter test

  fastlane:
    runs-on: ubuntu-latest
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v3
      - name: Emular Fastlane (após merge)
        run: echo "Executando Fastlane após merge na main!"
```

---

## Observações
- O job fastlane pode ser facilmente adaptado para rodar comandos reais do Fastlane.
