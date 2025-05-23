#!/bin/bash

# Verifica se um nome foi fornecido
if [ -z "$1" ]; then
    echo "Por favor, forneça o novo nome do projeto"
    echo "Uso: ./rename_project.sh novo_nome_do_projeto"
    exit 1
fi

NEW_NAME=$1
OLD_NAME="sql_offline"

# Função para substituir texto em arquivos
replace_in_file() {
    local file=$1
    local search=$2
    local replace=$3
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        sed -i '' "s|$search|$replace|g" "$file"
    else
        # Linux
        sed -i "s|$search|$replace|g" "$file"
    fi
}

echo "Iniciando renomeação do projeto para: $NEW_NAME"

# pubspec.yaml
echo "Atualizando pubspec.yaml..."
replace_in_file "pubspec.yaml" "^name: .*" "name: $NEW_NAME"

# android/app/build.gradle
echo "Atualizando build.gradle..."
replace_in_file "android/app/build.gradle" "applicationId \"com.example.$OLD_NAME\"" "applicationId \"com.example.$NEW_NAME\""

# ios/Runner.xcodeproj/project.pbxproj
echo "Atualizando project.pbxproj..."
replace_in_file "ios/Runner.xcodeproj/project.pbxproj" "PRODUCT_NAME = $OLD_NAME" "PRODUCT_NAME = $NEW_NAME"

# macos/Runner/Configs/AppInfo.xcconfig
echo "Atualizando AppInfo.xcconfig..."
replace_in_file "macos/Runner/Configs/AppInfo.xcconfig" "PRODUCT_NAME = $OLD_NAME" "PRODUCT_NAME = $NEW_NAME"

# windows/runner/main.cpp
echo "Atualizando main.cpp..."
replace_in_file "windows/runner/main.cpp" "window.SetTitle(L\"$OLD_NAME\"" "window.SetTitle(L\"$NEW_NAME\""

# web/index.html
echo "Atualizando index.html..."
replace_in_file "web/index.html" "<title>$OLD_NAME</title>" "<title>$NEW_NAME</title>"

echo "Projeto renomeado com sucesso para: $NEW_NAME"

# Executando flutter clean e flutter pub get
echo "Executando flutter clean..."
flutter clean

echo "Executando flutter pub get..."
flutter pub get

echo "Processo de renomeação concluído com sucesso!" 