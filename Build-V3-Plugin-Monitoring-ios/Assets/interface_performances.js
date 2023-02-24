
/*
 The DOMContentLoaded event fires when the initial HTML document has been completely loaded and parsed, without waiting for stylesheets, images, and subframes to finish loading.
 */
window.addEventListener('DOMContentLoaded', (event) => {
    var d = {};
    d.eventName = 'DOMContentLoaded';
    if (window.webkit) {
        window.webkit.messageHandlers.bryj_performance_domcontentloaded.postMessage(d);
    } else {
        window.bryj_performance.DOMContentLoaded();
    }
});


document.addEventListener('readystatechange', (event) => {
    if (document.readyState == 'complete') {
        var d = {};
        d.eventName = 'readystatechange.complete';
        if (window.webkit) {
            window.webkit.messageHandlers.bryj_performance_readystatechange_complete.postMessage(d);
            
        } else {
            window.bryj_performance.readystatechange_complete();
        }
    }
    
    if (document.readyState == 'interactive') {
        var d = {};
        d.eventName = 'readystatechange.interactive';
        if (window.webkit) {
            window.webkit.messageHandlers.bryj_performance_readystatechange_interactive.postMessage(d);

        } else {
            window.bryj_performance.readystatechange_interactive();
        }
    }
});

/*
 The load event is fired when the whole page has loaded, including all dependent resources such as stylesheets and images.
 */
window.addEventListener('load', (event) => {
    var d = {};
    d.eventName = 'load';
    if (window.webkit) {
        window.webkit.messageHandlers.bryj_performance_load.postMessage(d);

    } else {
        window.bryj_performance.load();
    }
});


// https://web.dev/fid/
new PerformanceObserver((entryList) => {
  for (const entry of entryList.getEntries()) {
    const delay = entry.processingStart - entry.startTime;
    console.log('FID candidate:', delay, entry);
  }
}).observe({type: 'first-input', buffered: true});

// https://web.dev/lcp/
new PerformanceObserver((entryList) => {
  for (const entry of entryList.getEntries()) {
    console.log('LCP candidate:', entry.startTime, entry);
  }
}).observe({type: 'largest-contentful-paint', buffered: true});

// https://web.dev/fcp/
new PerformanceObserver((entryList) => {
  for (const entry of entryList.getEntriesByName('first-contentful-paint')) {
    console.log('FCP candidate:', entry.startTime, entry);
  }
}).observe({type: 'paint', buffered: true});

// https://web.dev/cls/
let clsValue = 0;
let clsEntries = [];

let sessionValue = 0;
let sessionEntries = [];

new PerformanceObserver((entryList) => {
  for (const entry of entryList.getEntries()) {
    // Only count layout shifts without recent user input.
    if (!entry.hadRecentInput) {
      const firstSessionEntry = sessionEntries[0];
      const lastSessionEntry = sessionEntries[sessionEntries.length - 1];

      // If the entry occurred less than 1 second after the previous entry and
      // less than 5 seconds after the first entry in the session, include the
      // entry in the current session. Otherwise, start a new session.
      if (sessionValue &&
          entry.startTime - lastSessionEntry.startTime < 1000 &&
          entry.startTime - firstSessionEntry.startTime < 5000) {
        sessionValue += entry.value;
        sessionEntries.push(entry);
      } else {
        sessionValue = entry.value;
        sessionEntries = [entry];
      }

      // If the current session value is larger than the current CLS value,
      // update CLS and the entries contributing to it.
      if (sessionValue > clsValue) {
        clsValue = sessionValue;
        clsEntries = sessionEntries;

        // Log the updated value (and its entries) to the console.
        console.log('CLS:', clsValue, clsEntries)
      }
    }
  }
}).observe({type: 'layout-shift', buffered: true});
