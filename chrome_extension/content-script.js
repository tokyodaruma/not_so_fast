let targetUrl = window.location.href;
const isoDateString = new Date().toISOString();

const myHeaders = new Headers({
  'Content-Type': 'application/json',
  'Authorization': 'wosGYhyXq734unPsyxBM'
});

const notification = {
  "notification":
  {
      "accessed_at": isoDateString,
      "read": false,
      "description": `Accessed ${targetUrl}`
  }
}

const request = new Request('http://localhost:3000/api/v1/notifications', {
  method: 'POST',
  headers: myHeaders,
  mode: 'cors',
  body: JSON.stringify(notification)
 });

fetch(request)
  .then(checkStatus)
  .then(response => response.json())
  .then(data => {
    console.log(data);
  })
  .catch((error) => {
    console.log('There was an error', error);
  });


function checkStatus(response) {
  if (response.ok) {
      return response;
  }

  let error = new Error(response.statusText);
  error.response = response;
  return Promise.reject(error);
}
