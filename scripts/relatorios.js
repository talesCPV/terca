
function print_jogos(dt){
    doc = new jsPDF({
        orientation: 'portrait',
        format: 'a4'
    }) 

    txt.y = 10

    plotImg('assets/logo.png',5,5,80)
    doc.text(dt.racha.data,170,10)
//    addPage(0)

    doc.setFont(undefined, 'bold')
    doc.setFontSize(12);
    addLine(3)

    let i = 0
    let max_y = txt.y

    while(dt.times[String.fromCharCode(65+i)] != undefined){
        doc.setFont(undefined, 'bold')
        doc.setFontSize(12);
            doc.text(`Time ${String.fromCharCode(65+i)}`,40+60*i,txt.y)
        for (let j=0; j<dt.times[String.fromCharCode(65+i)].length; j++) { 
            doc.setFont(undefined, 'normal')
            doc.setFontSize(10);
            doc.text(dt.times[String.fromCharCode(65+i)][j].nome,40+60*i,txt.y+7+j*7)
            max_y = max_y > txt.y+7+j*7 ? max_y : txt.y+7+j*7
        }
        i++
    }

/*
    for (const [key, time] of Object.entries(dt.times)) { 
        console.log(key)

        doc.setFont(undefined, 'bold')
        doc.setFontSize(12);
            doc.text(`Time ${key}`,40+60*i,txt.y)
        for (let j=0; j<time.length; j++) { 
            doc.setFont(undefined, 'normal')
            doc.setFontSize(10);
            doc.text(time[j].nome,40+60*i,txt.y+7+j*7)
            max_y = max_y > txt.y+7+j*7 ? max_y : txt.y+7+j*7
        }
        i++
    }
*/
    txt.y = max_y
    addLine(3)
    doc.setFont(undefined, 'bold')
    doc.setFontSize(18)
    center_text('Resultados')
    addLine()
    doc.setFont(undefined, 'normal')
    doc.setFontSize(15)
    for(let i=0; i<20; i++){
        if(dt.jogos[i] != undefined){
            doc.text(`Time ${dt.jogos[i].time_1}   ${dt.jogos[i].placar_1.padStart(2,0)}   X   ${dt.jogos[i].placar_2.padStart(2,0)}   Time ${dt.jogos[i].time_2}`,70,txt.y+7+i*7)
        }else{
            const arr = ['A','B','C']
            doc.text(`Time ${arr[i%3]}   __   X   __   Time ${arr[(i+1)%3]}`,70,txt.y+7+i*7) 
        }


    }









    const blob = doc.output('blob')
    openPDF(doc,'times_&_jogos')

}

