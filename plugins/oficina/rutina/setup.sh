#!/usr/bin/env bash
# Script de preparación (opcional) del entorno de la nube de un proyecto de OficiosOsIA.
# Se pega en «Setup script» del entorno en claude.ai/code. Instala las CLI de Vercel y
# Supabase y los navegadores de Playwright. Se puede ejecutar varias veces sin romper nada
# y nunca imprime variables ni secretos.
set -euo pipefail

instalar_npm() {
  local paquete="$1" comando="$2"
  if command -v "$comando" >/dev/null 2>&1; then
    echo "· $comando ya está instalado"
  else
    echo "· Instalando $paquete…"
    npm install --global --no-fund --no-audit --loglevel=error "$paquete" >/dev/null
  fi
}

if ! command -v npm >/dev/null 2>&1; then
  echo "· No hay npm en este entorno: me salto las CLI de Vercel y Supabase."
  exit 0
fi

instalar_npm vercel vercel
instalar_npm supabase supabase

# Navegador para las pruebas E2E (QA de desarrollo y comprobaciones de seguridad en la preview).
# Solo Chromium, que es lo más usado. Si falla (sin red o sin permisos), se sigue igual.
if npx --yes playwright --version >/dev/null 2>&1; then
  npx --yes playwright install --with-deps chromium >/dev/null 2>&1 \
    && echo "· Chromium para Playwright listo" \
    || echo "· No se ha podido instalar Chromium para Playwright: se intentará en la sesión"
fi

echo "· Entorno de OficiosOsIA preparado"
