function pageOpen(pathName) {
  let id = "";
  if (pathName.indexOf('text_analyses/new') != -1) id = "text-analysis-form";
  if (pathName.indexOf('results/new') != -1) id = "result-form";
  return (id == "") ? null : document.getElementById(id).submit();
}

window.addEventListener('DOMContentLoaded', pageOpen(window.location.pathname));