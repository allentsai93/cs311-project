#!/bin/bash
pandoc --latex-engine=xelatex -i ./proposal.md -o ./proposal.pdf
pandoc --latex-engine=xelatex -i ./proposal.md -o ./proposal.docx
