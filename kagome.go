package main

import (
	"C"

	"fmt"
	"os"
	"runtime/debug"
	"strings"

	"github.com/ikawaha/kagome-dict/uni"
	"github.com/ikawaha/kagome/v2/tokenizer"
)

// global kagome tokenizer
var globalTokenizer tokenizer.Tokenizer
// has the tokenizer been initialized
var globalTokenizerInitialized bool = false



// ShowVersion prints the version about the tool.
//export ShowVersion
func ShowVersion() {
	var version, errorWriter = "", os.Stderr;

	info, ok := debug.ReadBuildInfo()
	if ok && version == "" {
		version = info.Main.Version
	}
	if version == "" {
		version = "(devel)"
	}
	fmt.Fprintln(errorWriter, version)
	if !ok {
		return
	}
	const prefix = "github.com/ikawaha/kagome-dict/"
	for _, v := range info.Deps {
		if strings.HasPrefix(v.Path, prefix) {
			fmt.Fprintln(errorWriter, "  ", v.Path[len(prefix):], v.Version)
		}
	}
}

//export InitTokenizer
func InitTokenizer() {
	
	tokenizer, err := tokenizer.New(uni.Dict(), tokenizer.OmitBosEos())
	if err != nil {
		panic(err)
	}

	globalTokenizer = *tokenizer;
	globalTokenizerInitialized = true;
}

//export DestroyTokenizer
func DestroyTokenizer() {
	globalTokenizer = tokenizer.Tokenizer{}
	globalTokenizerInitialized = false
}

//export RunWakati
func RunWakati(input *C.char) *C.char {
	
	if(!globalTokenizerInitialized){
		println("You did not initialize the tokenizer! Call InitTokenizer first...")
	}

	seg := globalTokenizer.Wakati(C.GoString(input))
	wakated := strings.Join(seg, "█")

	return C.CString(wakated)
}

//export RunAnalyzer
func RunAnalyzer(input *C.char, mode *C.char) *C.char {

	if(!globalTokenizerInitialized){
		println("You did not initialize the tokenizer! Call InitTokenizer first...")
	}

	analyzeMode := 1
	if C.GoString(mode) == "normal" {
		analyzeMode = 1
	} else if C.GoString(mode) == "search" {
		analyzeMode = 2
	} else if C.GoString(mode) == "extended" {
		analyzeMode = 3
	}

	tokens := globalTokenizer.Analyze(C.GoString(input), tokenizer.TokenizeMode(analyzeMode))
	surfaceOut, featuresOut := "", ""
	for i, token := range tokens {
		features := ""

		// join the features together
		for j, t := range token.Features() {
			// if the feature is not empty 
			if (t != "") {
				features += t
			} else {
				features += " "
			}
			if (j < len(token.Features()) - 1){
				features += "█"
			}
		}

		surfaceOut  += token.Surface
		featuresOut += features
		
		if(len(tokens)-1 > i){
			surfaceOut  += "██"
			featuresOut += "██"
		}
	}
	return C.CString(surfaceOut + "███" + featuresOut)
}

func main() {
	InitTokenizer()
	tokens := globalTokenizer.Analyze("、", tokenizer.TokenizeMode(2))
	surfaceOut, featuresOut := "", ""

	for i, token := range tokens {
		features := ""

		// join the features together
		for j, t := range token.Features() {
			// if the feature is not empty 
			if (t != "") {
				features += t
			} else {
				features += " "
			}
			if (j < len(token.Features()) - 1){
				features += "█"
			}
		}

		surfaceOut  += token.Surface
		featuresOut += features
		
		if(len(tokens)-1 > i){
			surfaceOut  += "██"
			featuresOut += "██"
		}
	}

	print(surfaceOut + "███" + featuresOut)
}