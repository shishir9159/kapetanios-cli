package main

import (
  	"flag"
	"fmt"

	"github.com/shishir9159/kapetanios-cli/pkg/parser"
	"github.com/shishir9159/kapetanios-cli/pkg/ui"
	"github.com/rivo/tview"
)

// unified pkg parser and ui is work in progress

var (
	path = flag.String("path", "./", "specified start path. default is ./")
	help = flag.Bool("help", false, "displayed help message for kapetanios")
)

func main() {
	flag.Parse()

	if *help {
		fmt.Printf(`kapetanios-cli is a kubernetes admistration tool.

Usage:
	kapetanios-cli [options]

The options are:
	--path=$PATH specified start path. default is ./
	--help       displayed help message for itree
`,
		)
		return
	}

box := tview.NewBox().SetBorder(true).SetTitle("Hello, world!")
	if err := tview.NewApplication().SetRoot(box, true).Run(); err != nil {
		panic(err)
	}
}
