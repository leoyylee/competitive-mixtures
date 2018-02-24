#' Variables provided by the calling environment
#'
#' DUMP_FILE
#' FIT_FILE
#' OUT_DIR
#' MODEL_FILE
#'

source("src/within-host/view_helper.R")

#' Visualise the model fit
obs_array <- readRDS(gsub(".dump", "obs_array.rds", DUMP_FILE))
fit <- readRDS(FIT_FILE)
sol <- fit$par$sol
g_model_fit <- plot_model_solution(sol, obs_array)
verbose_ggsave(g_model_fit, sprintf("%s/model_fit.pdf", OUT_DIR))

#' Visualise the posterior distribution on the R0-ratio
source("src/within-host/dumper_helper.R")
source(DUMP_FILE)
params <- list(
    num_samples = 1E2,
    sf_obj = stan(MODEL_FILE, data = get_dump_vars(), chains = 0, iter = 0)
)
r0_samples <- r0_ratios(fit, params)
g_r0_vis <- plot_posterior_r0_ratios(r0_samples)
verbose_ggsave(g_r0_vis, sprintf("%s/approx_r0_posterior.pdf", OUT_DIR))

    