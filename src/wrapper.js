const SiteBuilder = (() => {
    const defaultSchema = [
        {
            name: "Text",
            fields: [
                { type: 'RichText', id: 'content', title: "Content" },
                { type: 'Text', id: 'className', title: "Class" }
            ]
        },
        {
            name: "Image",
            fields: [
                { type: 'Image', id: 'image', title: "Image" },
                { type: 'Text', id: 'className', title: "Class" },
            ]
        },
        {
            name: "Gallery",
            fields: [
                { type: 'Images', id: 'images', title: "Images" }
            ]
        },
        {
            name: "Slider",
            fields: [
                { type: 'Images', id: 'images', title: "Images" }
            ]
        },
        {
            name: "Html",
            fields: [
                { type: 'TextArea', id: 'html', title: "Html" }
            ]
        }
    ];

    const observe = observedNode => {
        const observer = new MutationObserver(mutationRecords => {
            mutationRecords.forEach(mutationRecord => {
                mutationRecord.addedNodes.forEach(node => {
                    if (node.className == 'sb-modal') {
                        node.querySelectorAll('.sb-quill').forEach(renderQuill);
                    }
                });
            });
        });
        observer.observe(observedNode, { childList: true, subtree: true });
    };

    const renderQuill = node => {
        const index = parseInt(node.dataset.index);
        const editor = node.querySelector('.sb-quill-editor');

        const trap = document.createElement('div');
        trap.style.display = 'none';
        const inner = document.createElement('div');
        trap.appendChild(inner);

        const quill = new Quill(editor, { theme: 'snow' });
        node.insertBefore(trap, node.firstChild);

        quill.on('text-change', () => {
            sb.ports.richTextInput.send([index, quill.root.innerHTML]);
        });
    };

    let sb;

    return {
        defaultSchema,
        init(options) {
            observe(options.container);

            sb = Elm.SiteBuilder.init({
                node: options.container,
                flags: {
                    schema: options.schema || defaultSchema,
                    data: options.data,
                    thumbnailsUrl: options.thumbnailsUrl
                }
            });

            sb.ports.openFileManager.subscribe(() => {
                options.fileManager.open();
            });

            options.fileManager.onClose = files => {
                sb.ports.fileManager.send(files);
            };
        }
    };
})();
