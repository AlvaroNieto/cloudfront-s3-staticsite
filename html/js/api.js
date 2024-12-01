// GET API REQUEST
async function get_visitors() {
    // call post api request function
    //await post_visitor();
    try {
        let response = await fetch('https://grhgkqp0zd.execute-api.eu-south-2.amazonaws.com/default/visit-counter-updater', {
            method: 'GET',
        });
        let data = await response.json()
        document.getElementById("visitors").innerHTML = data['curvisits'];
        console.log(data);
        return data;
    } catch (err) {
        console.error(err);
    }
}

get_visitors();
