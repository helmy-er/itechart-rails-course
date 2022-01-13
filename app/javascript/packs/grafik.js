let data=gon.data_income;
let data1 = gon.date_expenses
var now = new Date();
var firstDay = new Date(now.getFullYear(), now.getMonth(), 1)
drow(firstDay,now)
function drow(a,b) {
    let labels=date(a,b)
    const ctx = document.getElementById('myChart').getContext('2d');
    const myChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: 'доходы',
                data: setdata(labels),
                backgroundColor: [
                    'rgba(255, 99, 132, 1)',
                ],
                borderColor: [
                    'rgba(255, 99, 132, 1)',

                ],
                borderWidth: 1
            },{
                label: 'траты',
                data: setdata1(labels),
                backgroundColor: [

                    'rgba(54, 162, 235, 1)'
                ],
                borderColor: [
                    'rgba(54, 162, 235, 1)'
                ],
                borderWidth: 1
            }]
        },
    });
}
// заполняет дату расходов
function setdata(date) {
    let new_data=[]
    for (let days in date) {
        new_data.push(data[date[days]])
    }
    return new_data
}
// заполняет дату прибыли
function setdata1(date) {
    let new_data=[]
    for (let days in date) {
        new_data.push(data1[date[days]])
    }
    return new_data
}
// рисует график с новой датой
document.getElementById('newdate').onclick = function() {
    let start_date=new Date(document.getElementById('start').value)
    let end_date =new Date(document.getElementById('end').value)
    document.getElementById('myChart').remove()
    let div =  document. createElement('canvas')
    div.id='myChart'
    let place=document.getElementById('insert')
    place.append(div);
    drow(start_date,end_date)
};
// возращает список дат из диапазона
//
//
function date(date,date2){

    let set_date=[]
    console.log(date<date2)
    if (date2<date ){
        let buf=date2
        date2=date
        date=buf
    }
    while (date <= date2) {
        let day=date.getDate()
        let montn=date.getMonth()+1
        set_date.push(montn+'-'+day)
        date.setDate( date.getDate() + 1 )
    }
    return set_date
}