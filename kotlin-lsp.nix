{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  jdk21,
  zlib,
  freetype,
  fontconfig,
  alsa-lib,
  wayland,
  libxkbcommon,
  libX11,
  libXext,
  libxi,
  libxrender,
  libxtst,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "kotlin-lsp";
  version = "262.4739.0";

  src = fetchurl {
    url = "https://download-cdn.jetbrains.com/kotlin-lsp/${finalAttrs.version}/kotlin-server-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-RpcREMm4ozYM4/31Q3Rn9MRH2tN61z2/gdZK9neeQQU=";
  };

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];
  buildInputs = [
    stdenv.cc.cc.lib
    zlib
    freetype
    fontconfig
    alsa-lib
    wayland
    libxkbcommon
    libX11
    libXext
    libxi
    libxrender
    libxtst
  ];

  autoPatchelfIgnoreMissingDeps = [ "libc.musl-x86_64.so.1" ];
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share $out/bin
    cp -r . $out/share/kotlin-lsp
    chmod +x $out/share/kotlin-lsp/bin/intellij-server

    makeWrapper $out/share/kotlin-lsp/bin/intellij-server $out/bin/kotlin-lsp \
      --set JAVA_HOME ${jdk21.home} \
      --prefix PATH : ${jdk21}/bin

    runHook postInstall
  '';
})
