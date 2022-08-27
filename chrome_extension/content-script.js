let targetUrl = window.location.host;
let checkUrl = window.location.href;
let referrerUrl = window.document.referrer;
const isoDateString = new Date().toISOString();

const myHeaders = new Headers({
  'Content-Type': 'application/json',
  'X-User-Token': 'N2Pe8Ujr62hpCoN86ieN',
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
      border-radius: 18px;
      background-color: grey;
      margin-left: auto;
      margin-right: auto;
      align-items: center;
      flex-direction: column;
      color: red;
      height: 500px;
      width: 500px;">
      <svg version="1.1" id="Capa_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
      width="150px" height="150px" viewBox="0 0 478.125 478.125" style="enable-background:new 0 0 478.125 478.125;"
      xml:space="preserve">
        <g>
          <g>
            <g>
              <circle cx="239.904" cy="314.721" r="35.878"/>
              <path d="M256.657,127.525h-31.9c-10.557,0-19.125,8.645-19.125,19.125v101.975c0,10.48,8.645,19.125,19.125,19.125h31.9
                c10.48,0,19.125-8.645,19.125-19.125V146.65C275.782,136.17,267.138,127.525,256.657,127.525z"/>
              <path d="M239.062,0C106.947,0,0,106.947,0,239.062s106.947,239.062,239.062,239.062c132.115,0,239.062-106.947,239.062-239.062
                S371.178,0,239.062,0z M239.292,409.734c-94.171,0-170.595-76.348-170.595-170.596c0-94.248,76.347-170.595,170.595-170.595
                s170.595,76.347,170.595,170.595C409.887,333.387,333.464,409.734,239.292,409.734z"/>
            </g>
          </g>
        </g>
      </svg>
        <h1>NotSofast malicious  blocked</h1>
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
          "referral_site": referrerUrl,
          "detections": data.detections,
          "risk_score": data.risk_score,
          "status": "pending",
          "is_domain_recent": data.is_domain_recent,
          "webpage_title": data.webpage_title
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
