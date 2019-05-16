var SiteBuilder = function () {
  var defaultSchema = [{
    name: "Text",
    fields: [{
      type: 'RichText',
      id: 'content',
      title: "Content"
    }, {
      type: 'Text',
      id: 'className',
      title: "Class"
    }]
  }, {
    name: "Title",
    fields: [{
      type: 'Text',
      id: 'text',
      title: "Text"
    }]
  }, {
    name: "Image",
    fields: [{
      type: 'Image',
      id: 'image',
      title: "Image"
    }, {
      type: 'Text',
      id: 'className',
      title: "Class"
    }]
  }, {
    name: "Gallery",
    fields: [{
      type: 'Images',
      id: 'images',
      title: "Images"
    }]
  }, {
    name: "Slider",
    fields: [{
      type: 'Images',
      id: 'images',
      title: "Images"
    }]
  }, {
    name: "Html",
    fields: [{
      type: 'TextArea',
      id: 'html',
      title: "Html"
    }]
  }];

  var observe = function observe(observedNode) {
    var observer = new MutationObserver(function (mutationRecords) {
      mutationRecords.forEach(function (mutationRecord) {
        mutationRecord.addedNodes.forEach(function (node) {
          if (node.className == 'sb-modal') {
            node.querySelectorAll('.sb-quill').forEach(renderQuill);
          }
        });
      });
    });
    observer.observe(observedNode, {
      childList: true,
      subtree: true
    });
  };

  var renderQuill = function renderQuill(node) {
    var index = parseInt(node.dataset.index);
    var editor = node.querySelector('.sb-quill-editor');
    var trap = document.createElement('div');
    trap.style.display = 'none';
    var inner = document.createElement('div');
    trap.appendChild(inner);
    var quill = new Quill(editor, {
      theme: 'snow'
    });
    node.insertBefore(trap, node.firstChild);
    quill.on('text-change', function () {
      sb.ports.richTextInput.send([index, quill.root.innerHTML]);
    });
  };

  var sb;
  return {
    defaultSchema: defaultSchema,
    init: function init(options) {
      observe(options.container);
      sb = Elm.SiteBuilder.init({
        node: options.container,
        flags: {
          schema: options.schema || defaultSchema,
          data: options.data,
          thumbnailsUrl: options.thumbnailsUrl
        }
      });
      sb.ports.openFileManager.subscribe(function () {
        options.fileManager.open();
      });

      options.fileManager.onClose = function (files) {
        sb.ports.fileManager.send(files);
      };
    }
  };
}();
