let targetUrl = window.location.href;
const isoDateString = new Date().toISOString();

const myHeaders = new Headers({
  'Content-Type': 'application/json',
  'Authorization': 'haSiFxuWvwf8B2nLg2cM'
});

const notification = {
  "notification":
  {
      "accessed_at": isoDateString,
      "read": false,
      "description": `Accessed ${targetUrl}`
  },

  "site":
  {
    "url": `${targetUrl}`,
    "reason": `Accessed ${targetUrl}`,
    "referral_site": `${targetUrl}`
  }
}

const request = new Request('https://notsofast.co/api/v1/notifications', {
  method: 'POST',
  headers: myHeaders,
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
