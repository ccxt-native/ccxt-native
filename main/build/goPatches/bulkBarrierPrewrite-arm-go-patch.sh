#!/bin/bash
# needed to completely fix `fatal error: bulkBarrierPreWrite: unaligned arguments`
# patched the Go tool-chain to stop cgo from producing structs that violate ARM64 alignment, rebuilt the tool, and regenerated your iOS framework.

goroot=$(go env GOROOT)
sudo sed -i '' 's|fmt.Fprintf(fgcc, "\\ttypedef %s %v _cgo_argtype;\\n", ctype.String(), p.packedAttribute())|fmt.Fprintf(fgcc, "\\ttypedef %s %v __attribute__((aligned(8))) _cgo_argtype;\\n", ctype.String(), p.packedAttribute())|' ${goroot}/src/cmd/cgo/out.go  # https://github.com/golang/go/issues/46893#issuecomment-3225950918
# for go < 1.25 use
# sed -i '' 's|fmt.Fprintf(fgcc, "\\ttypedef %s %v _cgo_argtype;\\n", ctype, p.packedAttribute())|fmt.Fprintf(fgcc, "\\ttypedef %s %v __attribute__((aligned(8))) _cgo_argtype;\\n", ctype, p.packedAttribute())|' ${goroot}/src/cmd/cgo/out.go  # https://github.com/golang/go/issues/46893#issuecomment-1020386887
cd "$goroot/src"
sudo go install -a std cmd/cgo
