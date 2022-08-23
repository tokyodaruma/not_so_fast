let targetUrl = window.location.host;
let checkUrl = window.location.href;
const isoDateString = new Date().toISOString();

const myHeaders = new Headers({
  'Content-Type': 'application/json',
  'X-User-Token': 'vddwy9Giq_TPMiGYxsDy',
  'X-User-Email': "fake@fake.me"
});

// create an object to check if a site is blocked
const checkIfSiteIsBlocked = new Request('https://www.notsofast.co/api/v1/sites', {
  method: 'GET',
  headers: myHeaders
  });

  const siteIsBlocked = fetch(checkIfSiteIsBlocked)
  .then(checkStatus)
  .then(response => response.json())
  .then(sites => {
    if (typeof sites !== "undefined") {
      for (let count in sites) {
        if (sites[count].status=="blocked" && sites[count].url == targetUrl) {
          console.log("blocked");
          return "blocked";
        } else if (sites[count].status=="trusted" && sites[count].url == targetUrl) {
          console.log("trusted");
          return "trusted";
        } else if (sites[count].status == "pending" && sites[count].url == targetUrl) {
          return "pending"
        }
      }
      return "create notification"
    }
    else {
      console.log('this hit');
      return "create notification"
    }
  })
  .catch((error) => {
    console.log('There was an error', error);
  });

  const blocked_site = `
  <body style="background-color: #BED8D4;">
    <div class="blocked"
      style="display: flex;
      justify-content: center;
      border-radius: 8px;
      background-color: white;
      margin-left: auto;
      margin-right: auto;
      margin-top: 120px;
      height: 500px;
      width: 500px;">
      <div class="header">
        <h1>Domain is blocked</h1>
      </div>
    </div>
  </body>
  `;

  siteIsBlocked
    .then((result) => {
      if (result=="blocked") {
        document.documentElement.innerHTML = '';
        document.documentElement.innerHTML = blocked_site;
        document.documentElement.scrollTop = 0;
      } else if (result=="trusted" || result=="pending") {
        console.log("do nothing");
      } else {
        console.log(result);
        checkRiskScore();
      }
    })
    .catch(err=>console.log(err))

// create an object to store the risk score
function checkRiskScore() {
  const urlCheck = {
    "site":
    {
      "url": checkUrl
    }
  }

  const riskRequest = new Request('https://www.notsofast.co/api/v1/sites/risk-check', {
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
}

// create a notification + site item
function createNotification(notifications) {
  const request = new Request('https://www.notsofast.co/api/v1/notifications', {
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
