
echo "Start PDF Generation for Tillich Lectures"

mkdir -p tex

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

cd ..

rm -rf tex

echo "✓ PDF generated: html/tillich-lectures.pdf"

echo "Generating individual lecture PDFs..."

mkdir -p tex_single html/lectures

for xml in data/lectures/*.xml; do
    base=$(basename "$xml" .xml)

    echo " → Processing $base"

    java -jar saxon/saxon9he.jar \
        -s:"$xml" \
        -xsl:xslt/to_latex_single.xsl \
        -o:"tex_single/$base.tex"

    cd tex_single

    xelatex -interaction=nonstopmode "$base.tex" > /dev/null
    xelatex -interaction=nonstopmode "$base.tex" > /dev/null

    mv "$base.pdf" "../html/lectures/$base.pdf"

    cd ..

    rm -f "tex_single/$base."{aux,log,tex}
done

rm -rf tex_single 

echo "✓ Individual lecture PDFs generated in html/lectures/"