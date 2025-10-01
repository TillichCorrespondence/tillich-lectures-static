
echo "Start PDF Generation for Tillich Lectures"

# Check if Saxon exists
if [ ! -f "saxon/saxon9he.jar" ]; then
    echo "❌ Saxon not found. Run: ./shellscripts/dl_saxon.sh"
    exit 1
fi

# Check if xelatex is available
if ! command -v xelatex &> /dev/null; then
    echo "❌ xelatex not found. Install with:"
    echo "   sudo apt install texlive-xetex texlive-latex-extra"
    exit 1
fi

# Create output directories
mkdir -p tex
mkdir -p html

echo "Running XSLT transformation..."
java -jar saxon/saxon9he.jar \
    -xsl:xslt/to_latex.xsl \
    -o:tex/tmp.tex \
    -s:xslt/to_latex.xsl

if [ $? -ne 0 ]; then
    echo "❌ XSLT transformation failed"
    exit 1
fi

echo "✓ XSLT transformation completed"

# Change to tex directory
cd tex

echo "Compiling LaTeX (pass 1)..."
xelatex -interaction=nonstopmode tmp.tex > /dev/null

echo "Compiling LaTeX (pass 2)..."
xelatex -interaction=nonstopmode tmp.tex > /dev/null

# Move PDF to html directory
mv tmp.pdf ../html/tillich-lectures.pdf

# Cleanup temporary files
echo "🧹 Cleaning up..."
rm -f tmp.*
rm -f *.idx
rm -f *.ilg
rm -f *.ind
rm -f *.aux
rm -f *.log
rm -f *.toc
rm -f *.out

cd ..

echo "✓ PDF generated: html/tillich-lectures.pdf"