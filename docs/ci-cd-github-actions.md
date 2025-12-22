# Documentação CI/CD com GitHub Actions

## Objetivo

Este documento detalha a implementação de um pipeline de CI/CD utilizando GitHub Actions, com foco em preparar o ambiente para futura integração com o Fastlane. O objetivo é criar uma base sólida e modular para automações, facilitando a manutenção e a expansão do fluxo de trabalho em projetos Flutter.

---

## Estrutura dos Workflows

Foram criados workflows separados para cada etapa do pipeline, seguindo boas práticas de CI/CD:

- **Testes** (`test.yml`): Executa os testes automatizados do projeto.
- **Lint** (`lint.yml`): Realiza a análise estática do código.
- **Build** (`build.yml`): Compila o APK de debug e salva como artefato.
- **Emulação do Fastlane** (`emulate_fastlane.yml`): Simula a execução do Fastlane com um script de exemplo, preparando o terreno para a futura integração.

Todos os workflows estão configurados para rodar em qualquer branch (`branches: [ '**' ]`), permitindo flexibilidade para testes e desenvolvimento em múltiplas branches.

---

## Detalhamento dos Workflows

### 1. Testes (`.github/workflows/test.yml`)

- **Quando executa:**
  - Push ou Pull Request em qualquer branch.
- **O que faz:**
  - Faz checkout do código.
  - Instala o Flutter (versão 3.38.5).
  - Instala dependências (`flutter pub get`).
  - Executa os testes (`flutter test`).
- **Objetivo:**
  - Garantir que o código está funcional e que os testes automatizados passam em todas as branches.

### 2. Lint (`.github/workflows/lint.yml`)

- **Quando executa:**
  - Push ou Pull Request em qualquer branch.
- **O que faz:**
  - Faz checkout do código.
  - Instala o Flutter (versão 3.38.5).
  - Instala dependências.
  - Executa análise estática (`flutter analyze`).
- **Objetivo:**
  - Garantir a qualidade e padronização do código, evitando problemas de lint.

### 3. Build (`.github/workflows/build.yml`)

- **Quando executa:**
  - Push ou Pull Request em qualquer branch.
- **O que faz:**
  - Faz checkout do código.
  - Instala o Flutter (versão 3.38.5).
  - Instala dependências.
  - Compila o APK de debug (`flutter build apk --debug`).
  - Salva o APK gerado como artefato do workflow.
- **Objetivo:**
  - Garantir que o projeto compila corretamente e disponibilizar o APK para download e testes.

### 4. Emulação do Fastlane (`.github/workflows/emulate_fastlane.yml`)

- **Quando executa:**
  - Manualmente (workflow_dispatch), push ou pull request em qualquer branch.
- **O que faz:**
  - Depende do job de build.
  - Faz checkout do código.
  - Executa um script de exemplo (pode ser substituído pelo comando do Fastlane no futuro).
- **Objetivo:**
  - Simular a integração com o Fastlane, validando o encadeamento dos jobs e preparando o pipeline para automações de deploy.

---

## Como adaptar para o Fastlane

Quando desejar integrar o Fastlane, basta substituir o step de script do job `emulate_fastlane` por comandos reais do Fastlane, como:

```yaml
- name: Executar Fastlane
  run: bundle exec fastlane android beta
```

Também é possível adicionar jobs para build iOS, deploy em stores, geração de changelog, etc., conforme a necessidade do seu projeto.

---

## Benefícios desta abordagem

- **Modularidade:** Workflows separados facilitam manutenção e debugging.
- **Escalabilidade:** Fácil adicionar novas etapas ou integrações (ex: Fastlane, notificações, etc.).
- **Documentação:** Processo claro e replicável para outros projetos.
- **Flexibilidade:** Execução em qualquer branch, ideal para times com múltiplos fluxos de trabalho.

---

## Referências
- [GitHub Actions para Flutter](https://github.com/subosito/flutter-action)
- [Documentação oficial do GitHub Actions](https://docs.github.com/pt/actions)
