# Adicionar Arquivos Swift ao Projeto Xcode

## ⚠️ Problema
51 arquivos Swift existem no disco, mas apenas 4 estão no target do Xcode.
**O projeto não compila sem adicionar os arquivos restantes.**

## ✅ Solução Rápida (30 segundos)

### Passo 1: Abrir o Projeto
```bash
open WinampSpotifyPlayer.xcodeproj
```

### Passo 2: Adicionar Todos os Arquivos de Uma Vez

1. **No Xcode**, no painel esquerdo (Project Navigator):
   - Clique com botão direito na pasta **WinampSpotifyPlayer** (azul)
   - Selecione **"Add Files to 'WinampSpotifyPlayer'..."**

2. **Na janela que abrir**:
   - Navegue até a pasta `WinampSpotifyPlayer/` (a pasta do código fonte)
   - Selecione **TODAS** as subpastas:
     - `App/`
     - `Domain/`
     - `Data/`
     - `Presentation/`
     - `Core/`
     - `Services/`
     - `Resources/`

3. **Configurações importantes** (parte inferior da janela):
   - ✅ Marque **"Copy items if needed"**
   - ✅ Marque **"Create groups"** (NÃO selecione "Create folder references")
   - ✅ Em "Add to targets", marque **WinampSpotifyPlayer**

4. **Clique em "Add"**

### Passo 3: Verificar

No Project Navigator, você deve ver todos os arquivos organizados em pastas:
```
WinampSpotifyPlayer/
  ├── App/
  │   ├── WinampSpotifyPlayerApp.swift
  │   ├── AppDelegate.swift
  │   └── AppCoordinator.swift
  ├── Domain/
  │   ├── Models/
  │   └── UseCases/
  ├── Data/
  │   ├── Repositories/
  │   └── DTOs/
  ├── Presentation/
  │   ├── Views/
  │   ├── ViewModels/
  │   └── Components/
  ├── Core/
  ├── Services/
  └── Resources/
```

### Passo 4: Compilar

1. **Clean** o projeto: `⌘ + Shift + K`
2. **Build** o projeto: `⌘ + B`

## 🔍 Verificar Quantos Arquivos Foram Adicionados

Execute este comando no terminal:
```bash
cd /Users/viniciuscarvalho/Documents/WinampSpotifyPlayer
grep -c "\.swift in Sources" WinampSpotifyPlayer.xcodeproj/project.pbxproj
```

**Resultado esperado**: Deve mostrar aproximadamente 51 (ou mais)

## ❌ Se Houver Erros de Compilação

### Erro: "No such module 'SpotifyAPI'"
**Normal** - O projeto usa a Spotify Web API, não um módulo externo.

### Erro: Configuração do Spotify
Você precisa configurar as credenciais do Spotify em `SpotifyConfig.swift`:
```swift
enum SpotifyConfig {
    static let clientID = "SEU_CLIENT_ID_AQUI"
    static let redirectURI = "winampspotify://callback"
}
```

**Como obter credenciais**:
1. Acesse https://developer.spotify.com/dashboard
2. Crie uma aplicação
3. Copie o Client ID
4. Configure Redirect URI: `winampspotify://callback`

### Erro: Carbon Framework (Media Keys)
Se houver erro com `NX_KEYTYPE_PLAY`, verifique que `MediaKeyHandler.swift` usa `Int32`:
```swift
switch Int32(keyCode) {
case Int32(NX_KEYTYPE_PLAY):
    // ...
}
```

## 🎯 Resultado Final

Após adicionar os arquivos:
- ✅ Projeto compila sem erros de arquivos faltando
- ✅ Todos os 51+ arquivos Swift estão no target
- ⚠️ Ainda precisa configurar credenciais do Spotify para executar

## 📝 Próximos Passos

1. ✅ Adicionar arquivos ao Xcode (você está aqui)
2. ⚠️ Configurar credenciais do Spotify
3. ▶️ Executar o projeto (⌘+R)
