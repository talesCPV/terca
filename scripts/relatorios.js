
function print_jogos(dt){
    console.log(dt)

    doc = new jsPDF({
        orientation: 'portrait',
        format: 'a4'
    }) 

    plotImg('assets/logo.png',5,5,80)
    doc.text(dt.racha.data,170,10)
//    addPage(0)

    addLine(3)
    center_text('Times')




    const blob = doc.output('blob')
    openPDF(doc,'times_&_jogos')

}

