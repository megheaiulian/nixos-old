{ config, lib, pkgs, ... }:
{
  nixpkgs.overlays = [( self: super: {
    gtkd = super.stdenv.mkDerivation rec {
      name = "gtkd-3.6.5";
      version = "3.6.5";

      src = super.fetchzip {
        url = "https://gtkd.org/Downloads/sources/GtkD-3.6.5.zip";
        sha256 = "1ypxxqklad5wwyvc39wnphnqp5y4q5zbf9j5mxb3bg9vnls48vx1";
        stripRoot = false;
      };


      nativeBuildInputs = [ super.dmd super.pkgconfig super.which ];
      propagatedBuildInputs = [
        super.atk super.cairo super.gdk_pixbuf glib super.gstreamer super.gst_plugins_base gtk3 gtksourceview
        libgda libpeas super.librsvg super.pango vte
      ];

      prePatch = ''
        substituteAll ${./paths.d} generated/gtkd/gtkd/paths.d
        substituteInPlace src/cairo/gtkc/cairo-compiletime.d \
          --replace libcairo.so.2 ${super.cairo}/lib/libcairo.so.2 \
          --replace libcairo.dylib ${super.cairo}/lib/libcairo.dylib
        substituteInPlace src/cairo/gtkc/cairo-runtime.d \
          --replace libcairo.so.2 ${super.cairo}/lib/libcairo.so.2 \
          --replace libcairo.dylib ${super.cairo}/lib/libcairo.dylib
        substituteInPlace generated/gtkd/gtkc/gdkpixbuf.d \
          --replace libgdk_pixbuf-2.0.so.0 ${super.gdk_pixbuf}/lib/libgdk_pixbuf-2.0.so.0 \
          --replace libgdk_pixbuf-2.0.0.dylib ${super.gdk_pixbuf}/lib/libgdk_pixbuf-2.0.0.dylib
        substituteInPlace generated/gtkd/gtkc/atk.d \
          --replace libatk-1.0.so.0 ${super.atk}/lib/libatk-1.0.so.0 \
          --replace libatk-1.0.0.dylib ${super.atk}/lib/libatk-1.0.0.dylib
        substituteInPlace generated/gtkd/gtkc/pango.d \
          --replace libpango-1.0.so.0 ${super.pango.out}/lib/libpango-1.0.so.0 \
          --replace libpangocairo-1.0.so.0 ${super.pango.out}/lib/libpangocairo-1.0.so.0 \
          --replace libpango-1.0.0.dylib ${super.pango.out}/lib/libpango-1.0.0.dylib \
          --replace libpangocairo-1.0.0.dylib ${super.pango.out}/lib/libpangocairo-1.0.0.dylib
        substituteInPlace generated/gtkd/gtkc/gobject.d \
          --replace libgobject-2.0.so.0 ${glib}/lib/libgobject-2.0.so.0 \
          --replace libgobject-2.0.0.dylib ${glib}/lib/libgobject-2.0.0.dylib
        substituteInPlace generated/gtkd/gtkc/rsvg.d \
          --replace librsvg-2.so.2 ${super.librsvg}/lib/librsvg-2.so.2 \
          --replace librsvg-2.2.dylib ${super.librsvg}/lib/librsvg-2.2.dylib
        substituteInPlace generated/gtkd/gtkc/cairo.d \
          --replace libcairo.so.2 ${super.cairo}/lib/libcairo.so.2 \
          --replace libcairo.dylib ${super.cairo}/lib/libcairo.dylib
        substituteInPlace generated/gtkd/gtkc/gdk.d \
          --replace libgdk-3.so.0 ${gtk3}/lib/libgdk-3.so.0 \
          --replace libgdk-3.0.dylib ${gtk3}/lib/libgdk-3.0.dylib
        substituteInPlace generated/peas/peasc/peas.d \
          --replace libpeas-1.0.so.0 ${libpeas}/lib/libpeas-1.0.so.0 \
          --replace libpeas-gtk-1.0.so.0 ${libpeas}/lib/libpeas-gtk-1.0.so.0 \
          --replace libpeas-1.0.0.dylib ${libpeas}/lib/libpeas-1.0.0.dylib \
          --replace gtk-1.0.0.dylib ${libpeas}/lib/gtk-1.0.0.dylib
        substituteInPlace generated/vte/vtec/vte.d \
          --replace libvte-2.91.so.0 ${vte}/lib/libvte-2.91.so.0 \
          --replace libvte-2.91.0.dylib ${vte}/lib/libvte-2.91.0.dylib
        substituteInPlace generated/gstreamer/gstreamerc/gstinterfaces.d \
          --replace libgstvideo-1.0.so.0 ${super.gst_plugins_base}/lib/libgstvideo-1.0.so.0 \
          --replace libgstvideo-1.0.0.dylib ${super.gst_plugins_base}/lib/libgstvideo-1.0.0.dylib
        substituteInPlace generated/sourceview/gsvc/gsv.d \
          --replace libgtksourceview-3.0.so.1 ${gtksourceview}/lib/libgtksourceview-3.0.so.1 \
          --replace libgtksourceview-3.0.1.dylib ${gtksourceview}/lib/libgtksourceview-3.0.1.dylib
        substituteInPlace generated/gtkd/gtkc/glib.d \
          --replace libglib-2.0.so.0 ${glib}/lib/libglib-2.0.so.0 \
          --replace libgmodule-2.0.so.0 ${glib}/lib/libgmodule-2.0.so.0 \
          --replace libgobject-2.0.so.0 ${glib}/lib/libgobject-2.0.so.0 \
          --replace libglib-2.0.0.dylib ${glib}/lib/libglib-2.0.0.dylib \
          --replace libgmodule-2.0.0.dylib ${glib}/lib/libgmodule-2.0.0.dylib \
          --replace libgobject-2.0.0.dylib ${glib}/lib/libgobject-2.0.0.dylib
        substituteInPlace generated/gtkd/gtkc/gio.d \
          --replace libgio-2.0.so.0 ${glib}/lib/libgio-2.0.so.0 \
          --replace libgio-2.0.0.dylib ${glib}/lib/libgio-2.0.0.dylib
        substituteInPlace generated/gstreamer/gstreamerc/gstreamer.d \
          --replace libgstreamer-1.0.so.0 ${super.gstreamer}/lib/libgstreamer-1.0.so.0 \
          --replace libgstreamer-1.0.0.dylib ${super.gstreamer}/lib/libgstreamer-1.0.0.dylib
        substituteInPlace generated/gtkd/gtkc/gtk.d \
          --replace libgdk-3.so.0 ${gtk3}/lib/libgdk-3.so.0 \
          --replace libgtk-3.so.0 ${gtk3}/lib/libgtk-3.so.0 \
          --replace libgdk-3.0.dylib ${gtk3}/lib/libgdk-3.0.dylib \
          --replace libgtk-3.0.dylib ${gtk3}/lib/libgtk-3.0.dylib
      '';

      installFlags = "prefix=$(out)";

      #inherit atk cairo gdk_pixbuf librsvg pango;
      inherit (super.gnome3) glib gtk3 gtksourceview libgda libpeas vte;
      inherit (super.gst_all_1) gstreamer;
      gst_plugins_base = super.gst_all_1.gst-plugins-base;

      meta = with super.stdenv.lib; {
        description = "D binding and OO wrapper for GTK+";
        homepage = "https://gtkd.org";
        licence = licenses.lgpl3Plus;
        platforms = platforms.linux ++ platforms.darwin;
      };
    };
  })];
}
