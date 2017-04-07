SELECT
  object_id, ra, dec,
  -- PSF magnitudes
  gmag_psf, gmag_psf_err,
  rmag_psf, rmag_psf_err,
  imag_psf, imag_psf_err,
  zmag_psf, zmag_psf_err,
  ymag_psf, ymag_psf_err,
  -- Galaxy or star?
  iclassification_extendedness,
  -- Absorptions: probably SFD?
  a_g, a_r, a_i, a_z, a_y

FROM
 s16a_wide.forced

WHERE
  -- Search 2 degrees some (ra,dec)
  coneSearch(coord, 237.37051, 42.34841, 60)

  -- Primary object (see below) only
  AND detect_is_primary

  -- Forced-measurement was done with reference to i-band
  AND merge_measurement_i

  -- Hopefully just stars
  AND iclassification_extendedness < 0.1

  -- Centroid algorithm succeeded in all bands
  AND NOT gcentroid_sdss_flags
  AND NOT rcentroid_sdss_flags
  AND NOT icentroid_sdss_flags

  -- CModel flux algorithm succeeded in all bands
  AND NOT gflux_psf_flags
  AND NOT rflux_psf_flags
  AND NOT iflux_psf_flags

  -- Not at the edges of images
  AND NOT gflags_pixel_edge
  AND NOT rflags_pixel_edge
  AND NOT iflags_pixel_edge

  -- Center 3x3 pixels are not interpolated
  AND NOT gflags_pixel_interpolated_center
  AND NOT rflags_pixel_interpolated_center
  AND NOT iflags_pixel_interpolated_center

  -- Center 3x3 pixels are not saturated
  AND NOT gflags_pixel_saturated_center
  AND NOT rflags_pixel_saturated_center
  AND NOT iflags_pixel_saturated_center

  -- Center 3x3 pixels are not contaminated by cosmic rays
  AND NOT gflags_pixel_cr_center
  AND NOT rflags_pixel_cr_center
  AND NOT iflags_pixel_cr_center

  -- Not on bad pixels of CCDs
  AND NOT gflags_pixel_bad
  AND NOT rflags_pixel_bad
  AND NOT iflags_pixel_bad

  LIMIT 10;
;
