load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 

begin

   plotname = "figure_data_on_se_grid"
   plotform = "pdf" 

   vn = "T"

   lev_approx_pres = 500. ;; hPa 

   fna = "input1_ne30np4_T.nc"
   fnb = "input2_ne30np4_T.nc"

   fla = addfile(fna, "r")
   flb = addfile(fnb, "r")

   lat = fla->lat                     ; (ncol)  ... 48602
   lon = fla->lon                     ;
   lev = fla->lev                     ;

   wks = gsn_open_wks(plotform,plotname)

   res                       = True     ; plot mods desired
;; res@gsnMaximize           = True     
   res@gsnDraw               = False        ; do not draw picture
   res@gsnFrame              = False        ; do not advance frame

   res@cnFillMode = "RasterFill"

  ;res@gsnAddCyclic          = False     
   res@cnFillOn              = True     ; turn on color fill
   res@cnFillPalette         = "amwg_blueyellowred"   ; set color map
   res@cnLinesOn             = False    ; turn of contour lines
   res@cnLineLabelsOn        = False    ; turn of contour line labels
   res@mpFillOn              = False
   res@mpCenterLonF          = 210      

;; sfXArray and sfYArray need to be set for the unstructured grid (e.g. SE) 
   res@sfXArray              = lon 
   res@sfYArray              = lat

   vva = fla->$vn$
   vvb = flb->$vn$

   ndim = dimsizes(dimsizes(vva)) 
 
   if(ndim.eq.2) then 
      va = vva  
      vb = vvb  
   end if 

   print("level : " + lev_approx_pres + " hPa" ) 

   if(ndim.eq.3) then 
      va = vva(:,{lev_approx_pres},:)  
      vb = vvb(:,{lev_approx_pres},:) 
   end if 

   va@long_name = "A) T in 2010-12"
   vb@long_name = "B) T in 2010-11"

   vc = va 
   vc = vb - va

   plot = new(3,graphic)    

   if(vn.eq."T") then 
      res@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
      res@cnLevels = fspan(210.,300.,10)
   end if 

   plot(0) = gsn_csm_contour_map_ce(wks,va(0,:), res)     ; make 1D array
   plot(1) = gsn_csm_contour_map_ce(wks,vb(0,:), res)     ; make 1D array


   vc@long_name = "B - A"

   if(vn.eq."T") then 
      delete(res@cnLevels) 
      res@cnLevels = (/-20., -16., -12., -8., -4., -2., 2., 4., 8., 12., 16., 20./) 
   end if

   plot(2) = gsn_csm_contour_map_ce(wks,vc(0,:), res)


; draw panel with white space added
   resP                 = True
   resP@gsnPanelYWhiteSpacePercent = 5
   resP@gsnPanelXWhiteSpacePercent = 5
   gsn_panel(wks,plot,(/3,1/),resP)

end




