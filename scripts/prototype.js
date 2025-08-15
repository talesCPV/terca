/*  PROTOTYPES  */

/*  STRING  */

String.prototype.maxWidth = (N=0)=>{
    return ((N>0 && N<this.length) ? this.valueOf().substring(0,N) : this.valueOf())
}

String.prototype.money = function(D=2){

    const text = this.valueOf().replace(',','.')    
    const num = text.split('.')[0].replace(/\D/g, "")
    let after_dot
    try{
        after_dot = text.split('.')[1].replace(/\D/g, "").padEnd(2,0).substring(0,2)
    }catch{
        after_dot = '00'
    }

    let before_dot = ''
    for(let i=num.length-1; i>=0; i--){        
        before_dot = num[i] + before_dot        
        before_dot = (num.length-i)%3==0 && i>0 && i< num.length-1 ? '.'+before_dot : before_dot
    }
    return 'R$'+before_dot+'.'+after_dot
}

String.prototype.viewDate = function(){
    const str = this.valueOf()
    return (str.substring(8,10)+'/'+str.substring(5,7)+'/'+str.substring(0,4))
}

String.prototype.time = function(){
    const str = this.valueOf()
    return (str.substring(11,16))
}

String.prototype.viewFullDate = function(){
    const str = this.valueOf()
    const month = ['Janeiro','Fevereiro','Março','Abril','Maio','Junho','Julho','Agosto','Setembro','Outubro','Novembro','Dezembro']
    return `${str.substring(8,10)} de ${month[Number(str.substring(5,7))-1]} de ${str.substring(0,4)}`
}

String.prototype.viewXDate = function(){
    const month = ['Jan','Fev','Mar','Abr','Mai','Jun','Jul','Ago','Set','Out','Nov','Dez']
    const str = this.valueOf()
    const period = Number(str.substring(11,13)) >= 12 ? 'PM' : 'AM'
    const time = period == 'AM' ? str.substring(11,16) : Number(str.substring(11,13)) - 12 +  str.substring(13,16)
    return `${time} ${period} ${month[Number(str.substring(5,7))-1]}-${str.substring(8,10)}, ${str.substring(0,4)}`
}

/* DATE */
Date.prototype.change = function(N=1){
    this.setDate(this.getDate()+N)
 }

Date.prototype.addHour = function(N=1){
    this.setHours(this.getHours()+N)
}
 
Date.prototype.addMin = function(N=1){
    this.setTime(this.getTime() + N*60000)
}

Date.prototype.iniMonth = function(){
    return this.overday(-1*(this,this.getDate())+1)
}

Date.prototype.finMonth = function(){
    return new Date(this.getFullYear() ,this.getMonth()+1,0).getFormatDate()
}

Date.prototype.getFormatDate = function(N=''){
    if(N==''){
        return (`${this.getFullYear()}-${(this.getMonth()+1).toString().padStart(2,'0')}-${this.getDate().toString().padStart(2,'0')}`)
    }else{
        this.change(N)
        const out = `${this.getFullYear()}-${(this.getMonth()+1).toString().padStart(2,'0')}-${this.getDate().toString().padStart(2,'0')}`
        this.change(-N)
        return out
    }
}

Date.prototype.getFormatBR = function(){
    return (`${this.getDate().toString().padStart(2,'0')}/${(this.getMonth()+1).toString().padStart(2,'0')}/${this.getFullYear()}`)
}

Date.prototype.overday = function(N){
    const tmw = new Date(this)
        tmw.change(N)
        return  tmw.getFormatDate()
}

Date.prototype.getFullHour = function(){
    return (`${this.getHours().toString().padStart(2,'0')}:${this.getMinutes().toString().padStart(2,'0')}:${this.getSeconds().toString().padStart(2,'0')}`)
}

Date.prototype.getFullTime = function(){
    return (`${this.getHours().toString().padStart(2,'0')}:${this.getMinutes().toString().padStart(2,'0')}`)
}

Date.prototype.getFullDate = function(){
    return `${this.getFormatBR()} ${this.getFullHour()}`
}

Date.prototype.getFullDateTime = function(){
    return `${this.getFormatDate()}T${this.getFullHour()}-03:00`
}

Date.prototype.getWeekDay = function(){
    const dia = ['Dom','Seg','Ter','Qua','Qui','Sex','Sab']
    return dia[this.getDay()]
}

Date.prototype.getCod = function(){
    return this.getFullYear().toString().substring(2,4) + (this.getMonth()+1).toString().padStart(2,'0') + this.getDate().toString().padStart(2,'0')
}

/* TABLE */
HTMLTableElement.prototype.plot = function(obj, fields,type='',classname=''){
    fields = fields.split(',')
    type = type=='' ? '' : type.split(',')
    const tr = document.createElement('tr')
    tr.className = classname

    for(let i=0; i<fields.length; i++){
        const td = document.createElement('td')
        const arr = fields[i].split('|')
        if(arr.length > 1){
            td.classList = arr[1]
        }
        let html, op
    
        if(type.length > 0 && i<type.length){
            switch (type[i].substring(0,3)) {
                case 'int': // Numero Inteiro
                  html = parseInt(obj[arr[0]])
                  break;
                case 'flo': // Numero Decimal
                    html = obj[arr[0]] != null ? parseFloat(obj[arr[0]]).toFixed(2) : ''
                    break;

                case 'hor': // HORA 00:00
                    const a = obj[arr[0]] != null ? parseFloat(obj[arr[0]]).toFixed(2) : 0
                    html =  Math.floor(a).toString().padStart(2,0)+':'+ Math.round(parseFloat((a - Math.floor(a)) * 60)).toString().padStart(2,0)                    
                    break;

                case 'Upp': // Upper Case
                    html = obj[arr[0]] != null ? obj[arr[0]].toUpperCase().trim() : ''
                    break
                case 'str': // Valor literal
                    html = obj[arr[0]] != null ? obj[arr[0]].trim() : ''
                  break;
                case 'dat': // Formato de Data dia/mes/ano
                    html = obj[arr[0]] != null ? obj[arr[0]].substring(8,10)+'/'+ obj[arr[0]].substring(5,7)+'/'+obj[arr[0]].substring(0,4) : ''
                    break                 
                case 'Low': // Lower Case
                    html = obj[arr[0]] != null ? obj[arr[0]].toLowerCase().trim() : ''
                    break;
                case 'R$.': // Formato Monetário R$0,00
                    if(parseFloat(obj[arr[0]]).toFixed(2) >=0 ){
                        html = obj[arr[0]] != null ? viewMoneyBR(parseFloat(obj[arr[0]]).toFixed(2)) : ''
                    }else{
                        html = obj[arr[0]] != null ? `(${viewMoneyBR(parseFloat(obj[arr[0]]).toFixed(2))})` : ''
                    }
                    break
                case '%..':
                    html = obj[arr[0]] != null ?parseFloat(obj[arr[0]]).toFixed(2)+'%' : ''   // parseFloat(obj[arr[0]]).toFixed(2) + %
                    break;             
    
                case 'cha': // Troca palavra escolhida por outra valor_original=valor_desejado
                    op = type[i].split(' ')
                    html = ''
                    for(let j=1; j<op.length; j++){
                        if((obj[arr[0]] == op[j].split('=')[0])||(j==op.length-1 && html=='')||obj[arr[0]] == null ){
                            html = op[j].split('=')[1] == '**' ? obj[arr[0]] : op[j].split('=')[1]
                        }
                    }
                    break; 
                case 'ico':
                    op = type[i].split(' ')
                    html = ''
                    for(let j=1; j<op.length; j++){
                        if((obj[arr[0]] == op[j].split('=')[0])||(j==op.length-1 && html=='')||obj[arr[0]] == null ){
                            html =  `<span class="mdi ${op[j].split('=')[1] == '**' ? obj[arr[0]] : op[j].split('=')[1]}"></span>`
                        }
                    }
                    break;                     
                case 'ckb': // insere checkbox                      
                    html = `<input type="checkbox" id="tblCkb_${this.rows.length-1}" class="tbl-ckb" ${parseInt(obj[arr[0]])? '' : 'checked'}>`
                    break;
                case '<p>': // insere elemento P 
                    const cls = type[i].split('|')
                    const txt = obj[arr[0]].trim().split('=')                                      
                    html = `<p${cls.length>1 ? ' class="'+cls[1]+'"' : ''}>${txt[0]}</p>`
                    break;                    
                case 'cnp': // Formata CNPJ
                    html = obj[arr[0]] != null ? getCNPJ(obj[arr[0]].trim()) : ''
                    break;
                case 'ie.': // Formata Insc. Estadual
                    html = obj[arr[0]] != null ? getIE(obj[arr[0]].trim()) : ''
                    break;                    
                case 'btn': // Adiciona Botão
                    op = type[i].split(' ')
                    op = op.length > 1 ? op[1] : 'OK'                
                    html = `<button id="btn_${this.rows.length-1}" class="tbl-btn">${op}</button>`
                    break;
                case 'let':                            
                    html = arr[0]
                    break;                      
                default:
                  html = obj[arr[0]] != null ? obj[arr[0]] :''
            }            
        }else{
            html = obj[fields[i].split('|')[0]]
        }
        td.innerHTML = html
        tr.appendChild(td)
    }
    tr.data = obj
    this.appendChild(tr)
}

HTMLTableElement.prototype.head = function(hd){
    this.innerHTML = ''
    hd = hd.split(',')
    const tr = document.createElement('tr')
    for(let i=0; i<hd.length; i++){
        const th = document.createElement('th')
        const arr = hd[i].split('|')
        if(arr.length > 1){
            th.classList = arr[1]
        }
        if(arr[0] == 'ckb-all'){
            const all = document.createElement('input')
            all.type = 'checkbox'
            all.addEventListener('click',(e)=>{
                var nodes = Array.prototype.slice.call(e.target.parentNode.parentNode.children);
                const index = nodes.indexOf(e.target.parentNode)
                for(let i=1; i<this.rows.length; i++){
                    try{
                        this.rows[i].cells[index].children[index].checked = all.checked
                    }catch{
                        console.error('Erro controlado, vai ficar assim mesmo!');
                    }
                }
            })
            th.appendChild(all)
        }else{
            th.innerHTML = arr[0]
        }
        tr.appendChild(th)
    }
    this.appendChild(tr)
}

/* CLASSES */

class Pix{

    constructor(chave,valor,nome='',cidade='',codpgto='rachadeterca'){

        chave  = (chave.includes('@') && chave.includes('.com')) ? chave  : chave[0]=='+' ? '+' + getNum(chave) : getNum(chave)
        nome = nome.normalize('NFD').replace(/[\u0300-\u036f]/g, '').replace(/[^\w\s]|_/g, '').replace(/\s+/g, ' ').trim().substring(0,25)

        function addIndicator(nome,id,val){
            function tamArr(arr){
                let size = 0
                for(let i=0; i<arr.length; i++){
                    size += Number(arr[i].tam) + arr[i].id.length + arr[i].tam.length
                }
                return size
            }
            const ind = new Object
            ind.nome = nome
            ind.id = id.toString().padStart(2,0)
            ind.tam = (typeof(val)=='string' ? val.length : tamArr(val)).toString().padStart(2,0)
            ind.valor = val
            return ind
        }

        this.indicators = []
        this.indicators.push(addIndicator('Payload Format Indicator',0,'01'))

        const merchant = []
        merchant.push(addIndicator('GUI',0,'BR.GOV.BCB.PIX'))
        merchant.push(addIndicator('chave',1,chave))
        this.indicators.push(addIndicator('Merchant Account Information',26,merchant))

        this.indicators.push(addIndicator('Merchant Category Code',52,'0000'))
        this.indicators.push(addIndicator('Transaction Currency',53,'986'))
        this.indicators.push(addIndicator('Transaction Amount ',54,Number(valor).toFixed(2)))
        this.indicators.push(addIndicator('Country Code',58,'BR'))
        this.indicators.push(addIndicator('Merchant Name',59,nome))
        this.indicators.push(addIndicator('Merchant City',60,cidade))

        const Additional = []
        Additional.push(addIndicator('txid',5,codpgto))        
        this.indicators.push(addIndicator('Additional Data Field Template ',62,Additional))

//        this.indicators.push(addIndicator('CRC16',63,'1D3D'))

    }

}


Pix.prototype.computeCRC = (str, invert = false)=>{
    const bytes = new TextEncoder().encode(str);
    const crcTable = [0, 4129, 8258, 12387, 16516, 20645, 24774, 28903, 33032, 37161, 41290, 45419, 49548, 53677, 57806, 61935, 4657, 528, 12915, 8786, 21173, 17044, 29431, 25302, 37689, 33560, 45947, 41818, 54205, 50076, 62463, 58334, 9314, 13379, 1056, 5121, 25830, 29895, 17572, 21637, 42346, 46411, 34088, 38153, 58862, 62927, 50604, 54669, 13907, 9842, 5649, 1584, 30423, 26358, 22165, 18100, 46939, 42874, 38681, 34616, 63455, 59390, 55197, 51132, 18628, 22757, 26758, 30887, 2112, 6241, 10242, 14371, 51660, 55789, 59790, 63919, 35144, 39273, 43274, 47403, 23285, 19156, 31415, 27286, 6769, 2640, 14899, 10770, 56317, 52188, 64447, 60318, 39801, 35672, 47931, 43802, 27814, 31879, 19684, 23749, 11298, 15363, 3168, 7233, 60846, 64911, 52716, 56781, 44330, 48395, 36200, 40265, 32407, 28342, 24277, 20212, 15891, 11826, 7761, 3696, 65439, 61374, 57309, 53244, 48923, 44858, 40793, 36728, 37256, 33193, 45514, 41451, 53516, 49453, 61774, 57711, 4224, 161, 12482, 8419, 20484, 16421, 28742, 24679, 33721, 37784, 41979, 46042, 49981, 54044, 58239, 62302, 689, 4752, 8947, 13010, 16949, 21012, 25207, 29270, 46570, 42443, 38312, 34185, 62830, 58703, 54572, 50445, 13538, 9411, 5280, 1153, 29798, 25671, 21540, 17413, 42971, 47098, 34713, 38840, 59231, 63358, 50973, 55100, 9939, 14066, 1681, 5808, 26199, 30326, 17941, 22068, 55628, 51565, 63758, 59695, 39368, 35305, 47498, 43435, 22596, 18533, 30726, 26663, 6336, 2273, 14466, 10403, 52093, 56156, 60223, 64286, 35833, 39896, 43963, 48026, 19061, 23124, 27191, 31254, 2801, 6864, 10931, 14994, 64814, 60687, 56684, 52557, 48554, 44427, 40424, 36297, 31782, 27655, 23652, 19525, 15522, 11395, 7392, 3265, 61215, 65342, 53085, 57212, 44955, 49082, 36825, 40952, 28183, 32310, 20053, 24180, 11923, 16050, 3793, 7920];
    let crc = 65535;
    for (let i = 0; i < bytes.length; i++) {
      const c = bytes[i];
      const j = (c ^ crc >> 8) & 255;
      crc = crcTable[j] ^ crc << 8;
    }
    let answer = (crc ^ 0) & 65535;
    let hex = answer.toString(16).toUpperCase()
    if (invert)
      return hex.slice(2) + hex.slice(0, 2);
    return hex;
}

Pix.prototype.payload = function(){

    function getPayload(arr){
        let txt = ''
        for( let i=0; i<arr.length; i++){
            txt += arr[i].id + arr[i].tam + (typeof(arr[i].valor)=='string' ? arr[i].valor : getPayload(arr[i].valor))
        }
        return txt
    }

    const payload = getPayload(this.indicators) + '6304'

    return  payload + this.computeCRC(payload)
}


class Boleto{

    constructor(beneficiario,num_doc,venc,valor){
        this.beneficiario = beneficiario
        this.num_doc = num_doc
        this.venc = venc
        this.valor = getNum(valor)
        this.loadData()


    }

}

Boleto.prototype.loadData = function(){
    const data = new URLSearchParams()
    data.append("path",'/../config/data.json' )

    const myRequest = new Request("backend/loadFile.php",{
        method : "POST",
        body : data
    })

    const boleto = this

    const MyPromisse = new Promise((resolve,reject) =>{
        fetch(myRequest)
        .then(function (response){
            if (response.status === 200) { 
                response.text()
                .then((txt)=>{
                    const data = JSON.parse(txt)
                    const keys = Object.keys(data)
                    for(let i=0; i<keys.length; i++){
                        if(keys[i].substring(0,4)=='bol_'){
                            const field = keys[i].substring(4,9999)
                            boleto[field] = data[keys[i]]
                        }
                    }
                                   
                    console.log(boleto.segmento_p())
                    
                })
            } else { 
                reject(new Error("Houve algum erro na comunicação com o servidor"));
            } 
        })
    })
}

Boleto.prototype.head_arq  = function(){
    const today = new Date
    let out = ''
    out += Number(this.cod_banco).toString().padStart(3,0).substring(0,3)
    out += Number(this.lote_serv).toString().padStart(4,0).substring(0,4)
    out += Number(this.tipo_reg).toString().padEnd(1,0)[0]
    out += ''.padStart(8,' ')
    out += Number(this.tipo_inscr).toString().padEnd(1,2)[0]
    out += Number(this.inscricao).toString().padStart(15,0).substring(0,15)
    out += Number(this.cod_transm).toString().padStart(15,0).substring(0,15)
    out += ''.padStart(25,' ')
    out += this.razao_social.padEnd(30,' ').substring(0,30)
    out += this.nome_banco.padEnd(30,' ').substring(0,30)
    out += ''.padStart(10,' ')
    out += Number(this.cod_remessa).toString().padEnd(1,1)[0]
    out += today.getDate().toString().padStart(2,0) + (today.getMonth()+1).toString().padStart(2,0) + today.getFullYear().toString()
    out += ''.padStart(6,' ')
    out += Number(this.num_seq_arq).toString().padStart(6,0).substring(0,6)
    out += Number(this.num_layout).toString().padStart(3,0).substring(0,6)
    out += ''.padStart(74,' ')
    return out
}

Boleto.prototype.head_lote_remessa  = function(){
    const today = new Date
    let out = ''
    out += Number(this.cod_banco).toString().padStart(3,0).substring(0,3)
    out += Number(this.num_lote_rem).toString().padStart(4,0).substring(0,4)
    out += Number(this.tipo_reg).toString().padEnd(1,0)[0]
    out += 'R'
    out += Number(this.tipo_serv).toString().padStart(2,0).substring(0,2)
    out += ''.padStart(2,' ')
    out += Number(this.num_ver_lay_lote).toString().padStart(3,0).substring(0,3)
    out += ''.padStart(1,' ')
    out += Number(this.tipo_inscr).toString().padEnd(1,2)[0]
    out += Number(this.inscricao).toString().padStart(15,0).substring(0,15)
    out += ''.padStart(20,' ')
    out += Number(this.cod_transm).toString().padStart(15,0).substring(0,15)
    out += ''.padStart(5,' ')
    out += this.beneficiario.padEnd(30,' ').substring(0,30)
    out += this.mensagem_1.padEnd(40,' ').substring(0,40)
    out += this.mensagem_2.padEnd(40,' ').substring(0,40)
    out += Number(this.num_remessa_ret).toString().padStart(8,0).substring(0,8)
    out += today.getDate().toString().padStart(2,0) + (today.getMonth()+1).toString().padStart(2,0) + today.getFullYear().toString()
    out += ''.padStart(41,' ')
    return out
}

Boleto.prototype.segmento_p  = function(){
    const today = new Date
    let out = ''
    out += Number(this.cod_banco).toString().padStart(3,0).substring(0,3)
    out += Number(this.num_lote_rem).toString().padStart(4,0).substring(0,4)
    out += Number(this.tipo_reg).toString().padEnd(1,0)[0]
    out += Number(this.num_seq_lote).toString().padStart(5,0).substring(0,5)
    out += 'P'
    out += ''.padStart(1,' ')
    out += Number(this.cod_mov_remessa).toString().padStart(2,0).substring(0,2)
    out += Number(this.cod_ag_destinatario).toString().padStart(4,0).substring(0,4)
    out += Number(this.dig_ag_destinatario).toString().padStart(1,0).substring(0,1)
    out += Number(this.num_cc).toString().padStart(9,0).substring(0,9)
    out += Number(this.dig_ver_cc).toString().padStart(1,0).substring(0,1)
    out += Number(this.conta_cob_dest_FIDC).toString().padStart(9,0).substring(0,9)
    out += Number(this.dig_conta_cob_dest_FIDC).toString().padStart(1,0).substring(0,1)
    out += ''.padStart(2,' ')
    out += Number(this.nosso_numero).toString().padStart(13,0).substring(0,13)
    out += this.tipo_cobranca.padEnd(1,' ').substring(0,1)
    out += Number(this.forma_cadastro).toString().padStart(1,0).substring(0,1)
    out += Number(this.tipo_doc).toString().padStart(1,1).substring(0,1)
    out += ''.padStart(1,' ')
    out += ''.padStart(1,' ')
    out += this.num_doc.padEnd(15,' ').substring(0,15)
    out += this.venc.padEnd(15,' ').substring(0,15)
    out += this.valor.padEnd(15,' ').substring(0,15)
    out += this.ag_cobranca_FIDC.padEnd(4,' ').substring(0,4)
    out += this.dig_ag_cobranca_FIDC.padEnd(1,' ').substring(0,1)
    out += ''.padStart(1,' ')


    
    return out
}