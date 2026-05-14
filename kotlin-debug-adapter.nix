{
  stdenv,
  fetchurl,
  unzip,
  makeWrapper,
  jdk21,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "kotlin-debug-adapter";
  version = "0.4.4";

  src = fetchurl {
    url = "https://github.com/fwcd/kotlin-debug-adapter/releases/download/${finalAttrs.version}/adapter.zip";
    sha256 = "sha256-OHTLre0P24Ipo4EWeJWwpsr4i3rf+rxpD89ab7ZdEbY=";
  };

  nativeBuildInputs = [ unzip makeWrapper ];

  unpackPhase = ''
    runHook preUnpack
    unzip $src
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share $out/bin
    cp -r adapter $out/share/kotlin-debug-adapter
    chmod +x $out/share/kotlin-debug-adapter/bin/kotlin-debug-adapter

    makeWrapper $out/share/kotlin-debug-adapter/bin/kotlin-debug-adapter $out/bin/kotlin-debug-adapter \
      --set JAVA_HOME ${jdk21.home} \
      --prefix PATH : ${jdk21}/bin

    runHook postInstall
  '';
})
