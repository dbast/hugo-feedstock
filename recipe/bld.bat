@echo on

set GO111MODULE=on

cd %SRC_DIR%

if /I "%HOST_PLATFORM%"=="win-arm64" (
    rem conda-forge has no gcc/go-cgo cross-compiler for win-arm64, so cgo
    rem (needed by -tags extended) isn't available here. Build the plain
    rem non-extended binary instead.
    set CGO_ENABLED=0
    set GOOS=windows
    set GOARCH=arm64
    go build -buildmode=exe -ldflags "-s -w -X main.revision=conda-forge -X github.com/gohugoio/hugo/common/hugo.vendorInfo=conda-forge" -trimpath -v -o %LIBRARY_PREFIX%\bin\hugo.exe || exit 1
) else (
    set CGO_ENABLED=1
    go build -buildmode=exe -ldflags "-s -w -X main.revision=conda-forge -X github.com/gohugoio/hugo/common/hugo.vendorInfo=conda-forge -extldflags '-static'" -tags extended -trimpath -v -o %LIBRARY_PREFIX%\bin\hugo.exe || exit 1
)
rem Chroma's COPYING contains MIT plus OFL text, which go-licenses reports as unknown.
go-licenses save . --save_path .\library_licenses --ignore github.com/alecthomas/chroma/v2 || exit 1
mkdir .\library_licenses\github.com\alecthomas\chroma\v2 || exit 1
for /f "usebackq delims=" %%i in (`go list -m -f "{{ .Dir }}" github.com/alecthomas/chroma/v2`) do set CHROMA_DIR=%%i
copy "%CHROMA_DIR%\COPYING" .\library_licenses\github.com\alecthomas\chroma\v2\COPYING || exit 1
