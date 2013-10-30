import QtQuick 2.0
import Sailfish.Silica 1.0
import org.kde.calligra 1.0 as Calligra

DocumentPage {
    id: page;

    attachedPage: Component {
        PresentationThumbnailPage {
            document: doc;
        }
    }

    Calligra.Document {
        id: doc;
    }

    Calligra.View {
        id: v;
        anchors.fill: parent;
        document: doc;
    }

    SilicaFlickable {
        id: f;
        anchors.fill: parent;

        Calligra.ViewController {
            id: controller;
            view: v;
            flickable: f;
        }

        ScrollDecorator { flickable: f; }

        PinchArea {
            anchors.fill: parent;

            onPinchUpdated: {
                var newCenter = mapToItem( f, pinch.center.x, pinch.center.y );
                canvasController.zoom = pinch.scale;
            }
            onPinchFinished: { f.returnToBounds(); }

            MouseArea {
                anchors.fill: parent;
                onClicked: page.open = !page.open;
            }
        }
    }
    
    busy: doc.status != Calligra.DocumentStatus.Loaded;

    onStatusChanged: {
        //Delay loading the document until the page has been activated.
        if(status == PageStatus.Active) {
            doc.source = page.path;
        }
    }
}
