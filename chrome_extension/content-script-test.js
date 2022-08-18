let targetUrl = window.location.href;
const isoDateString = new Date().toISOString();

const myHeaders = new Headers({
  'Content-Type': 'application/json',
  'X-User-Token': '184yjGZ2NoJ4LeqnLMfD',
  'X-User-Email': "fake@fake.me"
});

const urlCheck = {
  "site":
  {
    "url": targetUrl
  }
}

// create an object to store the risk score
let risk_score = 0;

const riskRequest = new Request('http://localhost:3000/api/v1/sites/risk-check', {
  method: 'POST',
  headers: myHeaders,
  body: JSON.stringify(urlCheck)
 });

fetch(riskRequest)
  .then(checkStatus)
  .then(response => response.json())
  .then(data => {
    const notifications = {
      "notification":
      {
          "accessed_at": isoDateString,
          "read": false,
          "description": `${data.detections} other site(s) flagged this as a risky URL.`
      },

      "site":
      {
        "url": targetUrl,
        "reason": `A ${data.risk_score} risk score was given for this URL`,
        "referral_site": targetUrl,
        "detections": data.detections,
        "risk_score": data.risk_score,
        "status": "pending"
      }
    }
    if (data.risk_score > 1) {
      createNotification(notifications);
    };
  })
  .catch((error) => {
    console.log('There was an error', error);
});


function createNotification(notifications) {
  const request = new Request('http://localhost:3000/api/v1/notifications', {
    method: 'POST',
    headers: myHeaders,
    body: JSON.stringify(notifications)
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
}

function checkStatus(response) {
  if (response.ok) {
      return response;
  }

  let error = new Error(response.statusText);
  error.response = response;
  return Promise.reject(error);
}
