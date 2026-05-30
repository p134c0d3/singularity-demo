using Gtk;
using Singularity;
using Singularity.Widgets;

namespace Singularity.Apps {

    public class DemoApp : Singularity.Application {

        public DemoApp() {
            Object(application_id: "dev.sinty.demo",
                   flags: ApplicationFlags.DEFAULT_FLAGS);
        }

        protected override void activate() {
            var win = new DemoWindow(this);
            win.present();
        }
    }
}
