# Bem-vindo ao guia de contribuição da RCHLO

Obrigado por investir seu tempo em contribuir com nosso projeto! 

Neste guia, você terá uma visão geral do fluxo de trabalho de contribuição ao abrir uma edição, criar um PR, revisar e mesclar o PR.

Use o ícone do índice no canto superior esquerdo deste documento para obter um seção deste guia rapidamente.

## Guia do contribuidor

Para obter uma visão geral do projeto, leia o [README] (README.md). Aqui estão alguns recursos para ajudá-lo a começar com contribuições de código aberto:

- [Configurar Git] (https://docs.github.com/en/get-started/quickstart/set-up-git)
- [fluxo GitHub] (https://docs.github.com/en/get-started/quickstart/github-flow)
- [Colaborando com solicitações pull] (https://docs.github.com/en/github/collaborating-with-pull-requests)

## Começando

Para navegar em nossa base de código com confiança, leia o [README] (README.md).

### Problemas

#### Crie um novo problema

Se você detectar um problema, [pesquise se já existe um problema] (https://docs.github.com/en/github/searching-for-information-on-github/searching-on-github/searching- Issues-and-pull-requests # search-by-the-title-body-or-comments). 
Se um problema relacionado não existir, você pode abrir um novo problema.

#### Resolva um problema

Examine nossos problemas existentes para encontrar um que seja do seu interesse. 
Você pode restringir a pesquisa usando `rótulos` como filtros. 
Como regra geral, não atribuímos problemas a ninguém. Se você encontrar um problema para resolver, fique à vontade para abrir um PR com uma correção.

### Faça mudanças


#### Faça alterações na IU

Realize um fork do projeto, realize a implementação ou correção desejada e [crie uma solicitação pull] (# solicitação pull) para revisão.

#### Faça alterações localmente

1. [Instale Git LFS] (https://docs.github.com/en/github/managing-large-files/versioning-large-files/installing-git-large-file-storage).

2. Bifurque o repositório.
- Usando o GitHub Desktop:
  - [Introdução ao GitHub Desktop] (https://docs.github.com/en/desktop/installing-and-configuring-github-desktop/getting-started-with-github-desktop) irá guiá-lo na configuração do Desktop .
  - Assim que o Desktop estiver configurado, você pode usá-lo para [bifurcar o repositório] (https://docs.github.com/en/desktop/contributing-and-collaborating-using-github-desktop/cloning-and-forking- repositories-from-github-desktop)!

- Usando a linha de comando:
  - [Fork the repo] (https://docs.github.com/en/github/getting-started-with-github/fork-a-repo#fork-an-example-repository) para que você possa fazer suas alterações sem afetar o projeto original até que você esteja pronto para mesclá-los.

- Codespaces GitHub:
  - [Fork, edit, and preview] (https://docs.github.com/en/free-pro-team@latest/github/developing-online-with-codespaces/creating-a-codespace) usando [GitHub Codespaces ] (https://github.com/features/codespaces) sem ter que instalar e executar o projeto localmente.

3. Crie um branch de trabalho e comece com suas alterações!

### Confirme sua atualização

Faça as alterações quando estiver satisfeito com elas. Consulte o [guia de contribuição do Atom] (https://github.com/atom/atom/blob/master/CONTRIBUTING.md#git-commit-messages) para saber como usar emoji para enviar mensagens.

Assim que suas alterações estiverem prontas, não se esqueça da auto-avaliação!

### Auto-avaliação

Você deve sempre revisar seu próprio PR primeiro.

Para alterações de conteúdo, certifique-se de:

- [] Confirme se as mudanças atendem à experiência do usuário e aos objetivos descritos no plano de design de conteúdo (se houver).
- [] Compare as alterações de origem de sua solicitação pull com o teste para confirmar se a saída corresponde à origem e se tudo está sendo renderizado conforme o esperado. Isso ajuda a detectar problemas como erros de digitação, conteúdo que não segue o guia de estilo ou conteúdo que não é renderizado devido a problemas de versão. Lembre-se de que listas e tabelas podem ser complicadas.
- [] Revise o conteúdo quanto à precisão técnica.
- [] Se houver alguma falha na verificação em seu PR, solucione-a até que todas as verificações sejam aprovadas.

### Pull Request

Quando terminar com as alterações, crie uma solicitação pull, também conhecida como PR.
- Preencha o modelo "Pronto para revisão" para que possamos revisar seu PR. Este modelo ajuda os revisores a entender suas alterações, bem como o propósito de sua solicitação pull.
- Não se esqueça de [vincular PR ao problema] (https://docs.github.com/en/issues/tracking-your-work-with-issues/linking-a-pull-request-to-an-issue ) se você estiver resolvendo um.
- Habilite a caixa de seleção para [permitir edições do mantenedor] (https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/allowing-changes-to-a-pull-request-branch -created-from-a-fork) para que o branch possa ser atualizado para uma fusão.
Depois de enviar seu RP, um membro da equipe do Docs analisará sua proposta. Podemos fazer perguntas ou solicitar informações adicionais.
- Podemos solicitar que sejam feitas alterações antes que um PR possa ser mesclado, usando [alterações sugeridas] (https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/incorporating -feedback-in-your-pull-request) ou comentários de solicitação pull. Você pode aplicar as alterações sugeridas diretamente por meio da IU. Você pode fazer quaisquer outras alterações em seu fork e, em seguida, enviá-las para seu branch.
- Conforme você atualiza seu PR e aplica as alterações, marque cada conversa como [resolvida] (https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/commenting-on-a- pull-request # resolving-conversations).
- Se você tiver problemas de mesclagem, verifique este [tutorial git] (https://lab.github.com/githubtraining/managing-merge-conflicts) para ajudá-lo a resolver conflitos de mesclagem e outros problemas.

### Seu PR foi mesclado!

Parabéns: tada::tada: A equipe RCHLO agradece: sparkles :. 

Assim que seu PR for mesclado, suas contribuições ficarão disponíveis!

Agora que você faz parte da comunidade da RCHLO, não pare por aqui, estamos ansiosos pela sua próxima contrinuição.

## Segurança

***- Nunca salve informações sensiveis em arquivos no repositório de GIT!***

