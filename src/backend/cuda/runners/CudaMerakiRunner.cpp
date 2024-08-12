/* XMRig
 * Copyright (c) 2018-2021 SChernykh   <https://github.com/SChernykh>
 * Copyright (c) 2016-2021 XMRig       <https://github.com/xmrig>, <support@xmrig.com>
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#include "backend/cuda/runners/CudaMerakiRunner.h"
#include "3rdparty/libethash/data_sizes.h"
#include "backend/cuda/CudaLaunchData.h"
#include "backend/cuda/wrappers/CudaLib.h"
#include "base/io/log/Log.h"
#include "base/io/log/Tags.h"
#include "base/net/stratum/Job.h"
#include "base/tools/Chrono.h"
#include "crypto/meraki/MKCache.h"
#include "crypto/meraki/MKHash.h"


xmrig::CudaMerakiRunner::CudaMerakiRunner(size_t index, const CudaLaunchData &data) :
    CudaBaseRunner(index, data)
{
}


bool xmrig::CudaMerakiRunner::run(uint32_t /*startNonce*/, uint32_t *rescount, uint32_t *resnonce)
{
    return callWrapper(CudaLib::merakiHash(m_ctx, m_jobBlob, m_target, rescount, resnonce, &m_skippedHashes));
}


bool xmrig::CudaMerakiRunner::set(const Job &job, uint8_t *blob)
{
    if (!CudaBaseRunner::set(job, blob)) {
        return false;
    }

    m_jobBlob = blob;

    const uint64_t height = job.height();
    const uint32_t epoch = height / MKHash::EPOCH_LENGTH;

    MKCache& cache = MKCache::s_cache;
    {
        std::lock_guard<std::mutex> lock(MKCache::s_cacheMutex);
        cache.init(epoch);
    }

    const uint64_t start_ms = Chrono::steadyMSecs();

    const bool result = CudaLib::merakiPrepare(m_ctx, cache.data(), cache.size(), cache.l1_cache(), MKCache::dag_size(epoch), height, dag_sizes);
    if (!result) {
        LOG_ERR("%s " YELLOW("Meraki") RED(" failed to initialize DAG: ") RED_BOLD("%s"), Tags::nvidia(), CudaLib::lastError(m_ctx));
    }
    else {
        const int64_t dt = Chrono::steadyMSecs() - start_ms;
        if (dt > 1000) {
            double dag_in_mb = (double)MKCache::dag_size(epoch) / (1024.0 * 1024.0);
            LOG_INFO("%s " YELLOW("Meraki") " DAG for epoch " WHITE_BOLD("%u") " calculated " BLACK_BOLD("(%" PRIu64 "ms)") " %.2f GB", Tags::nvidia(), epoch, dt, dag_in_mb);
        }
    }

    return result;
}


void xmrig::CudaMerakiRunner::jobEarlyNotification(const Job&)
{
    CudaLib::merakiStopHash(m_ctx);
}
